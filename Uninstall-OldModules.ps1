<#
.SYNOPSIS
Uninstalls old module versions (ignoring old Windows PowerShell modules).

.FUNCTIONALITY
PowerShell Modules

.EXAMPLE
Uninstall-OldModules.ps1

Cleans up redundant old modules.
#>

#Requires -Version 3
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
# Indicates the modules should be forced to uninstall.
[switch] $Force
)
if(Get-Command Uninstall-PSResource -ErrorAction Ignore)
{
	Get-Module -ListAvailable |
		Where-Object {$_.ModuleBase -notlike '*\WindowsPowerShell\*'} |
		Group-Object Name |
		Where-Object Count -gt 1 |
		ForEach-Object {$_.Group |Sort-Object Version -Descending |Select-Object -Skip 1} |
		Where-Object {$Force -or $PSCmdlet.ShouldProcess("$($_.Name) v$($_.Version)",'Uninstall-PSResource')} |
		ForEach-Object {Uninstall-PSResource $_.Name -Version $_.Version -Confirm:$false}
}
elseif($PSVersionTable.PSVersion -lt [version]'6.0')
{
	Get-Module -ListAvailable |
		Group-Object Name |
		Where-Object Count -gt 1 |
		ForEach-Object {$_.Group |Sort-Object Version -Descending |Select-Object -Skip 1} |
		Where-Object {$Force -or $PSCmdlet.ShouldProcess("$($_.Name) v$($_.Version)",'Uninstall-Module')} |
		ForEach-Object {Uninstall-Module $_.Name -RequiredVersion $_.Version -Force:$Force}
}
else
{
	Get-Module -ListAvailable |
		Where-Object {$_.ModuleBase -notlike '*\WindowsPowerShell\*'} |
		Group-Object Name |
		Where-Object Count -gt 1 |
		ForEach-Object {$_.Group |Sort-Object Version -Descending |Select-Object -Skip 1} |
		Where-Object {$Force -or $PSCmdlet.ShouldProcess("$($_.Name) v$($_.Version)",'Uninstall-Module')} |
		ForEach-Object {Uninstall-Module $_.Name -RequiredVersion $_.Version -Force:$Force}
}
