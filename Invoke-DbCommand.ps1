<#
.Synopsis
    Queries a database and returns the results.
    
.Parameter Connection
    A DbConnection object used for the query.
    
.Parameter ConnectionName
    The name of a connection string from the ConfigurationManager's ConnectionStrings,
    used to create a connection for the query.
    
.Parameter Server
    The name of a server (and optional instance) to connect and use for the query.
    May be used with optional Database, Credential, and ConnectionProperties parameters.
    
.Parameter Database
    The the database to connect to on the server.
    
.Parameter Credential
    The credential to use when connecting to the server.
    If no credential is specified, a trusted connection is used.
    
.Parameter ConnectionProperties
    Additional connection properties to use when connecting to the server, such as Timeout.
    
.Parameter ConnectionString
    A complete connection string to create a connection to use for the query.
    
.Parameter ProviderName
    The database provider to use. System.Data.SqlClient by default.
    
.Parameter CommandText
    Depending on the CommandType value, this is the text of the query, the name of a
    stored procedure, or the name of a table.
    
.Parameter CommandType
    How to interpret and use the CommandText.
    Text by default (for a query).
    TableDirect to get the contents of the named table.
    StoredProcedure to execute a stored procedure.
    
.Parameter Parameters
    A hashtable of query (or stored procedure) parameters names and values.
    
.Parameter ScalarValue
    Indicates the query should return a single value, rather than a result set.
    
.Parameter NonQuery
    Indicates the query is not expected to return data, but affect the database.
    The number of rows affected will be retured.
    
.Component
    System.Data
    
.Link
    Connect-Database
    
.Link
    Disconnect-Database
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='Connection',Position=0,Mandatory=$true)]
[Data.Common.DbConnection]$Connection,
[Parameter(ParameterSetName='ConnectionName',Position=0,Mandatory=$true)]
[Alias('Name','N')][string]$ConnectionName,
[Parameter(ParameterSetName='Server',Position=0,Mandatory=$true)]
[Alias('ComputerName','CN','S')][string]$Server,
[Parameter(ParameterSetName='Server',Position=1)][Alias('D')][string]$Database,
[Parameter(ParameterSetName='Server')][PSCredential]$Credential,
[Parameter(ParameterSetName='Server')]
[Alias('ConnProps','CP')][Collections.Hashtable]$ConnectionProperties = @{},
[Parameter(ParameterSetName='ConnectionString',Position=0,Mandatory=$true)]
[Alias('CS')][string]$ConnectionString,
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[string]$ProviderName = 'System.Data.SqlClient',
[Parameter(ParameterSetName='Connection',Mandatory=$true)]
[Parameter(ParameterSetName='ConnectionName')]
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[Alias('SQL','Query','Text')][string]$CommandText,
[Parameter(ParameterSetName='Connection')]
[Parameter(ParameterSetName='ConnectionName')]
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[Alias('Type')][Data.CommandType]$CommandType = 'Text',
[Parameter(ParameterSetName='Connection')]
[Parameter(ParameterSetName='ConnectionName')]
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[Alias('Params')][Collections.Hashtable]$Parameters = @{},
[Parameter(ParameterSetName='Connection')]
[Parameter(ParameterSetName='ConnectionName')]
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[Alias('Value')][switch]$ScalarValue,
[Parameter(ParameterSetName='Connection')]
[Parameter(ParameterSetName='ConnectionName')]
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[Alias('NoValues')][switch]$NonQuery
)

$tempconn = !$Connection
if($tempconn)
{
    $Connection =
        if($ConnectionName) {Connect-Database.ps1 -ConnectionName $ConnectionName}
        elseif($ConnectionString) {Connect-Database.ps1 -ConnectionString $ConnectionString -ProviderName $ProviderName}
        else
        {
            $connargs = @{Server=$Server}
            if($Database) {$connargs.Add('Database',$Database)}
            if($Database) {$connargs.Add('Credential',$Credential)}
            if($Database) {$connargs.Add('Properties',$ConnectionProperties)}
            Connect-Database.ps1 @connargs
        }
}

$cmd = $Connection.CreateCommand()
$cmd.Connection  = $Connection
$cmd.CommandText = $CommandText
$cmd.CommandType = $CommandType
$Parameters.Keys |% {[void]$cmd.Parameters.AddWithValue($_,$Parameters.$_)}
if($NonQuery) {$data = $cmd.ExecuteNonQuery(); Write-Verbose "$data rows affected"}
elseif($ScalarValue) {$data = $cmd.ExecuteScalar()}
else
{
    $data = New-Object Data.DataTable
    Write-Verbose "Executing $($cmd.CommandType) in $($cmd.Connection.Database): $($cmd.CommandText)"
    $dr = $cmd.ExecuteReader()
    $data.Load($dr)
}

if($tempconn) {Disconnect-Database.ps1 $Connection}

$data