<#
.Synopsis
	Uninstalls old module versions.

.Parameter Force
	Indicates the modules should be forced to uninstall.
#>

#Requires -Version 3
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)][OutputType([void])] Param(
[switch] $Force
)

Get-Module -List |
    group Name |
    where Count -gt 1 |
    foreach {$_.Group |sort Version -Descending |select -Skip 1} |
    where {$PSCmdlet.ShouldProcess("$($_.Name) v$($_.Version)",'Uninstall-Module')} |
    foreach {Uninstall-Module $_.Name -RequiredVersion $_.Version -Force:$Force}
