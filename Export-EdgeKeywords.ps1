<#
.SYNOPSIS
Returns the configured search keywords from an Edge SQLite file.

.OUTPUTS
System.Management.Automation.PSObject containing the search keyword details.

.FUNCTIONALITY
System and updates

.EXAMPLE
Export-EdgeKeywords.ps1 |ConvertTo-Json |Out-File ~/backup/msedge-keywords.json utf8

Backs up Edge search keywords as JSON to a file.
#>

#Requires -Version 3
#Requires -Modules PSSQLite
[CmdletBinding()] Param(
# The path to the SQLite file containing the Edge keywords table to export.
[Parameter	(Position=0)][string] $Path = "$env:LocalAppData\Microsoft\Edge\User Data\Default\Web Data"
)
Invoke-SqliteQuery -DataSource $Path -Query "select * from keywords;"
