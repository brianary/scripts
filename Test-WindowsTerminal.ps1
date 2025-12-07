<#
.SYNOPSIS
Returns true if PowerShell is running within Windows Terminal.
#>

#Requires -Version 7
[CmdletBinding()] Param()
if(!$IsWindows) {return $false}
for($process = Get-Process -Id $PID; $process; $process = $process.Parent)
{
    if($process.ProcessName -eq 'WindowsTerminal') {return $true}
}
return $false
