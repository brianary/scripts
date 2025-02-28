<#
.SYNOPSIS
Returns the DOSKey-style console command history (up arrow or F8).

.OUTPUTS
System.Management.Automation.PSObject with these properties:

* Id: The position of the command in the console history.
* CommandLine: The command entered in the history.

.FUNCTIONALITY
Console

.EXAMPLE
Get-ConsoleHistory.ps1 -Like *readme*

Id CommandLine
-- -----------
30 gc .\README.md
56 gc .\README.md

.EXAMPLE
Get-ConsoleHistory.ps1 -Id 30

Id CommandLine
-- -----------
30 gc .\README.md
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='Id',Mandatory=$true)][int] $Id,
[Parameter(ParameterSetName='Like',Mandatory=$true)][string] $Like,
[Parameter(ParameterSetName='Match',Mandatory=$true)][string] $Match,
[Parameter(ParameterSetName='All')][switch] $All
)
$history = Get-PSReadLineOption |Select-Object -ExpandProperty HistorySavePath
switch($PSCmdlet.ParameterSetName)
{
	Id
	{
		[pscustomobject]@{
			Id = $Id
			CommandLine = Get-Content $history -TotalCount $Id |Select-Object -Last 1
		}
	}
	Like
	{
		$id = 0
		(Get-Content $history) |Where-Object {$id++; $_ -like $Like} |ForEach-Object {[pscustomobject]@{
			Id = $id
			CommandLine = $_
		}}
	}
	Match
	{
		Select-String -Pattern $Match -Path $history |ForEach-Object {[pscustomobject]@{
			Id = $_.LineNumber
			CommandLine = $_.Line
		}}
	}
	default
	{
		$id = 0
		Get-Content $history |ForEach-Object {[pscustomobject]@{Id=++$id;CommandLine=$_}}
	}
}
