<#
.SYNOPSIS
Uninstalls old module versions.

.FUNCTIONALITY
PowerShell Modules
#>

#Requires -Version 3
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)][OutputType([void])] Param(
# Indicates the modules should be forced to uninstall.
[switch] $Force
)

Get-Module -List |
	Where-Object {$PSVersionTable.PSVersion -lt [version]'6.0' -or $_.ModuleBase -notlike '*\WindowsPowerShell\*'} |
	Group-Object Name |
	Where-Object Count -gt 1 |
	ForEach-Object {$_.Group |sort Version -Descending |select -Skip 1} |
	Where-Object {$PSCmdlet.ShouldProcess("$($_.Name) v$($_.Version)",'Uninstall-Module')} |
	ForEach-Object {Uninstall-Module $_.Name -RequiredVersion $_.Version -Force:$Force}
