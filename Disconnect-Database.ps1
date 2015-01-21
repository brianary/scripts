<#
.Synopsis
Disposes a database connection, such as opened by Connect-Database.
.Parameter Connection
The DbConnection to close.
.Component
System.Data
#>

#require -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][Data.Common.DbConnection]$Connection
)

if($Connection.State -eq 'Open')
{Write-Verbose "Closing connection to $($Connection.DataSource) $($Connection.Database) (v$($Connection.ServerVersion))"}
$Connection.Dispose()
Write-Verbose "Connection $($Connection.State)"
