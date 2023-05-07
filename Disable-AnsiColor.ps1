<#
.SYNOPSIS
Disables ANSI terminal colors.

.FUNCTIONALITY
Console

.LINK
https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_ansi_terminals

.EXAMPLE
Disable-AnsiColor.ps1

Disables ANSI terminal colors.
#>

#Requires -Version 7.2
[CmdletBinding()] Param(
# Disable colors only for text redirected to files.
[switch] $HostOnly
)

$PSStyle.OutputRendering = $HostOnly ? 'Host' : 'PlainText'

