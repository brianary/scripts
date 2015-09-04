<#
.Synopsis
    Exports MS SQL script for an object from the given server.

.Description
    This allows exporting a single database object to a SQL script, rather than 
    a whole database as Export-DatabaseScripts.ps1 does.

    It can be particularly useful for creating an object-drop script, with all dependencies.

.Parameter Server
    The name of the server (and instance) to connect to.

.Parameter Database
    The name of the database to connect to on the server.

.Parameter Urn
    The Urn of the database object to script.
    Example: "Server[@Name='ServerName\Instance']/Database[@Name='DatabaseName']/Table[@Name='TableName' and @Schema='dbo']"

.Parameter Table
    The unquoted name of the table to script.
    Resolved using the Schema parameter.

.Parameter View
    The unquoted name of the view to script.
    Resolved using the Schema parameter.

.Parameter StoredProcedure
    The unquoted name of the stored procedure to script.
    Resolved using the Schema parameter.

.Parameter UserDefinedFunction
    The unquoted name of the user defined function to script.
    Resolved using the Schema parameter.

.Parameter Schema
    The unquoted name of the schema to use with the Table, View, StoredProcedure, or UserDefinedFunction parameters.
    Defaults to dbo.

.Parameter FilePath
    The file to export the script to.

.Parameter Encoding
    The file encoding to use for the SQL scripts.

.Parameter ScriptingOptions
    Provides a list of boolean SMO ScriptingOptions properties to set to true.

.Component
    Microsoft.SqlServer.ConnectionInfo

.Component
    Microsoft.SqlServer.Smo

.Component
    Microsoft.SqlServer.SqlEnum

.Link
    Export-DatabaseScripts.ps1

.Link
    https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.aspx

.Link
    https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.scriptingoptions_properties.aspx

.Link
    https://msdn.microsoft.com/en-us/library/cc646021.aspx

.Example
    Export-DatabaseObjectScript.ps1 ServerName\instance AdventureWorks2014 -Table Customer -Schema Sales -FilePath Sales.Customer.sql
    Exports table creation script to Sales.Customer.sql as UTF8.

.Example
    Export-DatabaseObjectScript.ps1 ServerName\instance AdventureWorks2014 -Table Customer -Schema Sales -FilePath DropCustomer.sql ScriptDrops WithDependencies SchemaQualify IncludeDatabaseContext
    Exports drop script of Sales.Customer and dependencies to DropCustomer.sql.
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Server,
[Parameter(Position=1,Mandatory=$true)][string] $Database,
[Parameter(ParameterSetName='Urn',Position=2,Mandatory=$true)][string] $Urn,
[Parameter(ParameterSetName='Table',Position=2,Mandatory=$true)][string] $Table,
[Parameter(ParameterSetName='View',Position=2,Mandatory=$true)][string] $View,
[Parameter(ParameterSetName='StoredProcedure',Position=2,Mandatory=$true)][Alias('proc','sproc')][string] $StoredProcedure,
[Parameter(ParameterSetName='UserDefinedFunction',Position=2,Mandatory=$true)][Alias('UDF','func')][string] $UserDefinedFunction,
[Parameter(ParameterSetName='Urn')]
[Parameter(ParameterSetName='Table')]
[Parameter(ParameterSetName='View')]
[Parameter(ParameterSetName='StoredProcedure')]
[Parameter(ParameterSetName='UserDefinedFunction')]
[string] $Schema = 'dbo',
[Parameter(Mandatory=$true)][string] $FilePath,
[ValidateSet('Unicode','UTF7','UTF8','UTF32','ASCII','BigEndianUnicode','Default','OEM')][string]$Encoding = 'UTF8',
[Parameter(ValueFromRemainingArguments=$true)][string[]] $ScriptingOptions = (@'
EnforceScriptingOptions ExtendedProperties Permissions DriAll Indexes Triggers ScriptBatchTerminator
'@.Trim() -split '\W+')
)

# load SMO
try
{
    [void][Microsoft.SqlServer.Management.Smo.Server]
    [void][Microsoft.SqlServer.Management.Smo.ScriptingOptions]
    Write-Verbose "Types already loaded."
}
catch
{
    $sqlsdk = Get-ChildItem "${env:ProgramFiles(x86)}\Microsoft SQL Server\Microsoft.SqlServer.Smo.dll","$env:ProgramFiles\Microsoft SQL Server\Microsoft.SqlServer.Smo.dll" -Recurse |
        ForEach-Object FullName |
        Select-Object -Last 1 |
        Split-Path
    Write-Verbose "Found SQL SDK DLLs in $sqlsdk"
    Add-Type -Path "$sqlsdk\Microsoft.SqlServer.ConnectionInfo.dll"
    Add-Type -Path "$sqlsdk\Microsoft.SqlServer.Smo.dll"
    Add-Type -Path "$sqlsdk\Microsoft.SqlServer.SqlEnum.dll"
}

# connect to database
$srv = New-Object Microsoft.SqlServer.Management.Smo.Server($Server)
$db = $srv.Databases[$Database]
if(!$db) {return}
Write-Verbose "Connected to $srv.$db $($srv.Product) $($srv.Edition) $($srv.VersionString) $($srv.ProductLevel) (Windows $($srv.OSVersion))"

# set up scripting options
$opts = New-Object Microsoft.SqlServer.Management.Smo.ScriptingOptions
$ScriptingOptions |
    % {
        if(($opts |Get-Member $_) -and $opts.$_ -is [bool]) {$opts.$_ = $true} 
        else {Write-Warning "Not a boolean scripting option: '$_'"}
    }
$opts.ToFileOnly = $true
$opts.FileName = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($FilePath)
$opts.Encoding = 
    if($Encoding -eq 'OEM') {$OutputEncoding.GetEncoder().Encoding}
    else {[Text.Encoding]::$Encoding}
Write-Verbose "Scripting options flags: $(($opts |Get-Member -MemberType Property |% Name |? {$opts.$_ -is [bool] -and $opts.$_}) -join ', ')"
Write-Verbose "Scripting options values: $(($opts |Get-Member -MemberType Property |% Name |? {$opts.$_ -isnot [bool] -and $opts.$_} |% {"$_=$($opts.$_)"}) -join ', ')"

$object = 
    if($Urn) { $db.Resolve($Urn) }
    elseif($Table) { $db.Tables[$Table,$Schema] }
    elseif($View) { $db.Views[$View,$Schema] }
    elseif($StoredProcedure) { $db.StoredProcedures[$StoredProcedure,$Schema] }
    elseif($UserDefinedFunction) { $db.UserDefinedFunctions[$UserDefinedFunction,$Schema] }

$object.Script($opts)
