<#
.SYNOPSIS
Create a common database object.

.INPUTS
System.String to initialize the database object.

.OUTPUTS
System.Data.Common.DbCommand (e.g. System.Data.SqlClient.SqlCommand) or
System.Data.Common.DbConnection (e.g. System.Data.SqlClient.SqlConnection) or
System.Data.Common.DbConnectionStringBuilder (e.g. System.Data.SqlClient.SqlConnectionStringBuilder),
as requested.

.FUNCTIONALITY
Database

.LINK
https://msdn.microsoft.com/library/system.data.common.dbproviderfactories.aspx

.EXAMPLE
New-DbProviderObject.ps1 SqlClient ConnectionStringBuilder 'Server=ServerName;Database=DbName;Integrated Security=True'

Key                 Value
---                 -----
Data Source         ServerName
Initial Catalog     DbName
Integrated Security True

.EXAMPLE
$conn = New-DbProviderObject.ps1 SqlClient Connection $connstr -Open

($conn contains an open DbConnection object.)

.EXAMPLE
$cmd = New-DbProviderObject.ps1 odbc Command -ConnectionString $connstr -StoredProcedure -OpenConnection

($cmd contains a DbCommand with a CommandType of StoredProcedure and an open connection to $connstr.)
#>

#Requires -Version 4
[CmdletBinding()][OutputType([Data.Common.DbCommand])][OutputType([Data.Common.DbConnection])]
[OutputType([Data.Common.DbConnectionStringBuilder])] Param(
# The invariant name of the DbProviderFactory to use to create the requested object.
[Parameter(Mandatory=$true,Position=0)][AllowEmptyString()][string]$ProviderName,
# The type of object to create.
[ValidateSet('Command','Connection','ConnectionStringBuilder')]
[Parameter(Mandatory=$true,Position=1)][string]$TypeName,
<#
A value to initialize the object with, such as CommandText for a Command object, or
a ConnectionString for a Connection or ConnectionStringBuilder.
#>
[Parameter(Position=2,ValueFromPipeline=$true)][Alias('Value')][string]$InitialValue,
<#
A connection string to use (when creating a Command object).
No connection will be made if not specified.
#>
[Parameter(Position=3)][Alias('CS')][string]$ConnectionString,
<#
Sets the CommandType property of a Command object to StoredProcedure.
Ignored for other objects.
#>
[switch]$StoredProcedure,
# Opens the Connection object (or Command connection) if an InitialValue was provided, ignored otherwise.
[switch]$OpenConnection
)

$obj = $null
$providers = [Data.Common.DbProviderFactories]::GetFactoryClasses() |ForEach-Object InvariantName
if($ProviderName -inotin $providers)
{
    if(!$ProviderName)
    {
        if($TypeName -eq 'ConnectionStringBuilder')
        { # e.g. System.Web.Security.AuthorizationStoreRoleProvider uses a provider-free connection string
            $obj = New-Object Data.Common.DbConnectionStringBuilder
        }
        else {throw "Unable to create a $TypeName without a provider. Available providers: $($providers -join ', ')"}
    }
    elseif("System.Data.$ProviderName" -iin $providers) {$ProviderName = "System.Data.$ProviderName"}
    else {$ProviderName = $providers |Where-Object {$_ -ilike "*$ProviderName*"} |Select-Object -First 1}
}
$obj =
    if($obj) {$obj}
    else
    {
        $provider = [Data.Common.DbProviderFactories]::GetFactory($ProviderName)
        $provider."Create$TypeName"()
    }
if($InitialValue)
{
    switch($TypeName)
    {
        Command
        {
            $obj.CommandText = $InitialValue
        }
        Connection
        {
            $obj.ConnectionString = $InitialValue
            if($OpenConnection){$obj.Open()}
        }
        ConnectionStringBuilder
        { # PowerShell must use the method form of SqlConnectionStringBuilder
            if($ProviderName) { $obj.set_ConnectionString($InitialValue) }
            else { $obj.ConnectionString=$InitialValue } # DbConnectionStringBuilder does not support method form
        }
    }
}
if($obj -is [Data.Common.DbCommand])
{
    if($StoredProcedure) { $obj.CommandType = 'StoredProcedure' }
    if($ConnectionString)
    { $obj.Connection = New-DbProviderObject.ps1 $ProviderName Connection $ConnectionString -OpenConnection:$OpenConnection }
}
$obj
