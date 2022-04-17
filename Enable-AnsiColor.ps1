<#
.SYNOPSIS
Enables ANSI terminal colors.

.PARAMETER HostOnly
Enable colors only for host console output.

.LINK
https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_ansi_terminals

.EXAMPLE
Enable-AnsiColor.ps1

Enables ANSI terminal colors.
#>

#Requires -Version 7.2
[CmdletBinding()] Param(
[switch] $HostOnly
)

$PSStyle.OutputRendering = $HostOnly ? 'Host' : 'Ansi'
