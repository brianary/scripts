<#
.SYNOPSIS
Sets a default dbatools connection, using a caller script's parameter values when available.

.FUNCTIONALITY
Database
#>

#Requires -Version 7
using module dbatools
[CmdletBinding()] Param(
# The server to use, by name or constructed via Connect-DbaInstance.
[Parameter(Position=0)][Alias('Parent','ServerInstance')][DbaInstanceParameter] $SqlInstance =
    (Get-Variable PSBoundParameters -ValueOnly -Scope 1 |ForEach-Object {$_ ? $_['SqlInstance'] : $null}),
# The the database to connect to on the server.
[Parameter(Position=1)][Alias('Name')][string] $Database =
    (Get-Variable PSBoundParameters -ValueOnly -Scope 1 |ForEach-Object {$_ ? $_['Database'] : $null}),
# Sets a default output type for Invoke-DbaQuery.
[ValidateSet('DataSet','DataTable','DataRow','PSObject','PSObjectArray','SingleValue')][string] $As
)
Set-ParameterDefault.ps1 Invoke-DbaQuery SqlInstance $SqlInstance -Scope 1
if($Database) {Set-ParameterDefault.ps1 Invoke-DbaQuery Database $Database -Scope 1}
if($As) {Set-ParameterDefault.ps1 Invoke-DbaQuery As $As -Scope 1}
