<#
.Synopsis
Exports MS SQL database structures from the given server and database as files, into a consistent folder structure.
.Parameter Server
The name of the server (and instance) to connect to.
.Parameter Database
The name of the database to connect to on the server.
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
.Example
Export-SqlScripts.ps1 ServerName\instance AdventureWorks2014
(outputs SQL scripts to files)
.Link
https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.aspx
.Link
https://msdn.microsoft.com/en-us/library/microsoft.sqlserver.management.smo.scriptingoptions_properties.aspx
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Server,
[Parameter(Position=1,Mandatory=$true)][string] $Database,
[Parameter(Position=2)][ValidateSet('Unicode','UTF7','UTF8','UTF32','ASCII','BigEndianUnicode','Default','OEM')][string]$Encoding = 'UTF8',
[Parameter(Position=3,ValueFromRemainingArguments=$true)][string[]] $ScriptingOptions = (@'
EnforceScriptingOptions ExtendedProperties Permissions DriAll Indexes Triggers ScriptBatchTerminator
'@.Trim() -split '\W+')
)

# load SMO
try
{
    [Microsoft.SqlServer.Management.Smo.Server]|Out-Null
    [Microsoft.SqlServer.Management.Smo.ScriptingOptions]|Out-Null
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
mkdir $Database -EA:SilentlyContinue |Out-Null ; pushd $Database

# set up scripting options
$opts = New-Object Microsoft.SqlServer.Management.Smo.ScriptingOptions
$ScriptingOptions |
    % {
        if(($opts |Get-Member $_) -and $opts.$_ -is [bool]) {$opts.$_ = $true} 
        else {Write-Warning "Not a boolean scripting option: '$_'"}
    }
$opts.ToFileOnly = $true
$opts.Encoding = 
    if($Encoding -eq 'OEM') {$OutputEncoding.GetEncoder().Encoding}
    else {[Text.Encoding]::$Encoding}
Write-Verbose "Scripting options flags: $(($opts |Get-Member -MemberType Property |% Name |? {$opts.$_ -is [bool] -and $opts.$_}) -join ', ')"
Write-Verbose "Scripting options values: $(($opts |Get-Member -MemberType Property |% Name |? {$opts.$_ -isnot [bool] -and $opts.$_} |% {"$_=$($opts.$_)"}) -join ', ')"

# map database SMO object collection properties to folder structure
$folder = @{
    # Property           = # Folder
    Assemblies           = 'Assemblies'
    Triggers             = 'Database Triggers'
    Defaults             = 'Defaults'
    ExtendedProperties   = 'Extended Properties'
    UserDefinedFunctions = 'Functions'
    Rules                = 'Rules'
    AsymmetricKeys       = 'Security\Asymmetric Keys'
    Certificates         = 'Security\Certificates'
    Roles                = 'Security\Roles'
    Schemas              = 'Security\Schemas'
    SymmetricKeys        = 'Security\Symmetric Keys'
    Users                = 'Security\Users'
    Sequences            = 'Sequences'
    FullTextCatalogs     = 'Storage\Full Text Catalogs'
    FullTextStopLists    = 'Storage\Full Text Stop Lists'
    PartitionFunctions   = 'Storage\Partition Functions'
    PartitionSchemes     = 'Storage\Partition Schemes'
    StoredProcedures     = 'Stored Procedures'
    Synonyms             = 'Synonyms'
    Tables               = 'Tables'
    UserDefinedDataTypes = 'Types\User-defined Data Types'
    XmlSchemaCollections = 'Types\XML Schema Collections'
    Views                = 'Views'
}
$brkr = @{ # not something we currently use
    ServiceContracts      = 'Service Broker\Contracts'
    # ?                   = 'Service Broker\Event Notifications'
    MessageTypes          = 'Service Broker\Message Types'
    Queues                = 'Service Broker\Queues'
    RemoteServiceBindings = 'Service Broker\Remote Service Bindings'
    Routes                = 'Service Broker\Routes'
    Services              = 'Service Broker\Services'
}

function ConvertTo-FileName($Name) { $Name -replace '[<>\\/"|\t]+','_' }

# script all mapped SMO object collection properties
# skip collections that are empty, only system objects, and only fixed roles
# skip system objects and fixed roles
$folder.Keys |
    ? {$db.$_.Count} |
    ? {$db.$_ -isnot [Microsoft.SqlServer.Management.Smo.DatabaseRoleCollection] -or ($db.$_ |? IsFixedRole -eq $false)} |
    ? {!($db.$_ |Get-Member IsSystemObject) -or ($db.$_ |? IsSystemObject -eq $false)} |
    % {
        mkdir $folder.$_ -EA:SilentlyContinue |Out-Null ; pushd $folder.$_
        $db.$_ |
            ? {!($_|Get-Member IsSystemObject) -or !($_.IsSystemObject)} |
            ? {$_ -isnot [Microsoft.SqlServer.Management.Smo.DatabaseRole] -or !($_.IsFixedRole)} |
            % {
                $opts.FileName = 
                    if($_|Get-Member Schema) {"$pwd\$(ConvertTo-FileName $_.Schema).$(ConvertTo-FileName $_.Name).sql"}
                    else {"$pwd\$(ConvertTo-FileName $_.Name).sql"}
                Write-Verbose "Export $($_.GetType().Name) $_ to $($opts.FileName)"
                $_.Script($opts)
            }
        popd # object collection folder
    }

popd # Database
