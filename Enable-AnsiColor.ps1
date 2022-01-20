<#
.Synopsis
	Enables ANSI terminal colors.

.Parameter HostOnly
	Enable colors only for host console output.

.Link
	https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_ansi_terminals

.Example
	Enable-AnsiColor.ps1

	Enables ANSI terminal colors.
#>

#Requires -Version 7.2
[CmdletBinding()] Param(
[switch] $HostOnly
)

$PSStyle.OutputRendering = $HostOnly ? 'Host' : 'Ansi'
