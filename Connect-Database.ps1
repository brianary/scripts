<#
.Synopsis
    Creates a SqlConnection from a connection string name, server name, or connection string, and opens it.

.Parameter ConnectionName
    The name of the connection string to use, from System.Configuration.ConfigurationManager's ConnectionStrings.

.Parameter Server
    The name of the server (and instance) to connect to.
    May be used with optional Database, Credential, and Properties parameters.

.Parameter Database
    The name of the database to connect to on the server.

.Parameter Credential
    The credential to use to connect to the server.
    If no credential is specified, a trusted connection is used.

.Parameter Properties
    Additional connection properties to use when connecting to the server, such as Timeout.

.Parameter ConnectionString
    A complete connection string to create the connection.

.Parameter ProviderName
    The database provider to use. System.Data.SqlClient by default.

.Component
    System.Configuration

.Component
    System.Data
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='ConnectionName',Position=0,Mandatory=$true)]
[Alias('Name','N')][string]$ConnectionName,
[Parameter(ParameterSetName='Server',Position=0,Mandatory=$true)]
[Alias('ComputerName','CN')][string]$Server,
[Parameter(ParameterSetName='Server',Position=1)][Alias('D')][string]$Database,
[Parameter(ParameterSetName='Server')][PSCredential]$Credential,
[Parameter(ParameterSetName='Server')][Collections.Hashtable]$Properties = @{},
[Parameter(ParameterSetName='ConnectionString',Position=0,Mandatory=$true)]
[Alias('CS')][string]$ConnectionString,
[Parameter(ParameterSetName='Server')]
[Parameter(ParameterSetName='ConnectionString')]
[string]$ProviderName = 'System.Data.SqlClient'
)
try{[void][Configuration.ConfigurationManager]}catch{Add-Type -AN System.Configuration}
try{[void][Data.Common.DbProviderFactories]}catch{Add-Type -AN System.Data}

if($ConnectionName)
{
    $cs = [Configuration.ConfigurationManager]::ConnectionStrings[$ConnectionName]
    $ConnectionString = $cs.ConnectionString
    $ProviderName = $cs.ProviderName
}

$factory =
    if(!$Server)
    {
        Write-Verbose "ConnectionString: $ConnectionString ($ProviderName)"
        [Data.Common.DbProviderFactories]::GetFactory($ProviderName)
    }
    else
    {
        $f = [Data.Common.DbProviderFactories]::GetFactory($ProviderName)
        $cs = $f.CreateConnectionStringBuilder()
        $Properties.Keys |% {$cs.Add($_,$Properties.$_)}
        if($cs.ContainsKey('Server')) {$cs.Add('Server',$Server)}
        else {Write-Warning "Unable to add server."}
        if($Database -and $cs.ContainsKey('Database')) {$cs.Add('Database',$Database)}
        else {Write-Warning "Unable to add database."}
        if(!$Credential)
        {
            if($cs.ContainsKey('Integrated Security')) {$cs.Add('Integrated Security','SSPI')}
            Write-Verbose "ConnectionString: $cs ($ProviderName)+"
        }
        else
        {
            if($cs.ContainsKey('UID')) {$cs.Add('UID',$Credential.UserName)}
            if($cs.ContainsKey('PWD'))
            {
                $cs.Add('PWD','********')
                Write-Verbose "ConnectionString: $cs ($ProviderName)"
                $cs.Add('PWD',$Credential.GetNetworkCredential().Password)
            }
            else {Write-Verbose "ConnectionString: $cs ($ProviderName)*"}
        }
        $ConnectionString = "$cs"
        $f
    }

$conn = $factory.CreateConnection()
$conn.ConnectionString = $ConnectionString
$conn.Open()
Write-Verbose "Connection $($conn.State) to $($conn.DataSource) $($conn.Database) (v$($conn.ServerVersion))"
$conn
