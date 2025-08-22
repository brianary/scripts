<#
.SYNOPSIS
Prints caller name and parameters to the host for debugging purposes.
#>

#Requires -Version 3
[CmdletBinding()] Param()
(Get-Variable MyInvocation -ValueOnly -Scope 1).{MyCommand}?.Name ?? '<anonymous>' |Write-Host -ForegroundColor Cyan
Get-Variable PSBoundParameters -ValueOnly -Scope 1 |ConvertTo-Json -Depth 100 |Write-Host -ForegroundColor DarkGray
