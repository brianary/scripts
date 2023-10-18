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
New-DbProviderObject.ps1 ConnectionStringBuilder 'Server=(localdb)\ProjectsV13;Database=AdventureWorks;Integrated Security=SSPI;Encrypt=True'

Key                 Value
---                 -----
Data Source         (localdb)\ProjectsV13
Initial Catalog     AdventureWorks
Integrated Security True
Encrypt             True

.EXAMPLE
$conn = New-DbProviderObject.ps1 Connection $connstr -Open

($conn contains an open DbConnection object.)

.EXAMPLE
$cmd = New-DbProviderObject.ps1 Command -ConnectionString $connstr -Provider Odbc -StoredProcedure -OpenConnection

($cmd contains an OdbcCommand with a CommandType of StoredProcedure and an open connection to $connstr.)
#>

#Requires -Version 7
[CmdletBinding()][OutputType([Data.Common.DbCommand])]
[OutputType([Data.Common.DbConnection])][OutputType([Data.Common.DbConnectionStringBuilder])] Param(
# The type of object to create.
[ValidateSet('Command','Connection','ConnectionStringBuilder')]
[Parameter(Mandatory=$true,Position=0)][string] $TypeName,
<#
A value to initialize the object with, such as CommandText for a Command object, or
a ConnectionString for a Connection or ConnectionStringBuilder.
#>
[Parameter(Position=2,ValueFromPipeline=$true)][Alias('Value')][string] $InitialValue,
# The DbProviderFactory subclass to use to create the object.
[ValidateSet('Odbc','OleDb','Oracle','Sql')][string] $Provider = 'Sql',
<#
A connection string to use (when creating a Command object).
No connection will be made if not specified.
#>
[Parameter(Position=3)][Alias('CS')][string] $ConnectionString,
<#
Sets the CommandType property of a Command object to StoredProcedure.
Ignored for other objects.
#>
[switch] $StoredProcedure,
# Opens the Connection object (or Command connection) if an InitialValue was provided, ignored otherwise.
[switch] $OpenConnection
)
Process
{
	$factory = switch($Provider)
	{
		Odbc {[Data.Odbc.OdbcFactory]::Instance}
		OleDb {[Data.OleDb.OleDbFactory]::Instance}
		Oracle {[Data.OracleClient.OracleClientFactory]::Instance}
		Sql {[Data.SqlClient.SqlClientFactory]::Instance}
	}
	$value = switch($TypeName)
	{
		Command {$factory.CreateCommand()}
		Connection {$factory.CreateConnection()}
		ConnectionStringBuilder {$factory.CreateConnectionStringBuilder()}
	}
	if($InitialValue)
	{
		switch($TypeName)
		{
			Command
			{
				$value.CommandText = $InitialValue
			}
			Connection
			{
				$value.ConnectionString = $InitialValue
				if($OpenConnection) {$value.Open()}
			}
			ConnectionStringBuilder
			{ # PowerShell must use the method form
				$value.set_ConnectionString($InitialValue)
			}
		}
	}
	if($TypeName -eq 'Command')
	{
		if($StoredProcedure) {$obj.CommandType = 'StoredProcedure'}
		if($ConnectionString)
		{$obj.Connection = New-DbProviderObject.ps1 Connection $ConnectionString -Provider:$Provider -OpenConnection:$OpenConnection}
	}
	return $value
}
