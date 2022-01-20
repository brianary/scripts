<#
.Synopsis
	Disables ANSI terminal colors.

.Parameter HostOnly
	Disable colors only for text redirected to files.

.Link
	https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_ansi_terminals

.Example
	Disable-AnsiColor.ps1

	Disables ANSI terminal colors.
#>

#Requires -Version 7.2
[CmdletBinding()] Param(
[switch] $HostOnly
)

$PSStyle.OutputRendering = $HostOnly ? 'Host' : 'PlainText'
