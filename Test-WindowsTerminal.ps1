<#
.SYNOPSIS
Returns true if PowerShell is running within Windows Terminal.

.FUNCTIONALITY
Windows Terminal

.LINK
https://aka.ms/terminal-documentation

.EXAMPLE
Test-WindowsTerminal.ps1

True
#>

#Requires -Version 7
[CmdletBinding()][OutputType([bool])] Param()
if(!$IsWindows) {return $false}
if($env:WT_SESSION) {return $true}
for($process = Get-Process -Id $PID; $process; $process = $process.Parent)
{
	if($process.ProcessName -eq 'WindowsTerminal') {return $true}
}
return $false
