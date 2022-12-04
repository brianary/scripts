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
Get-ConsoleHistory.ps1 |where CommandLine -like *readme*

Id CommandLine
-- -----------
30 gc .\README.md
56 gc .\README.md
#>

#Requires -Version 3
[CmdletBinding()] Param()

$id = 0
Get-Content $env:AppData\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt |
	foreach {[pscustomobject]@{Id=++$id;CommandLine=$_}}
