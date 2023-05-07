<#
.SYNOPSIS
Re-registers all installed Appx packages.

.NOTES
Must be run in Windows PowerShell, apparently.
Do not run in Windows Terminal.

.EXAMPLE
Repair-AppxPackages.ps1

Repairs what Windows Store apps it can when run from PowerShell 5.1 (not in Windows Terminal) as admin.
#>

#Requires -RunAsAdministrator
#Requires -Modules Appx
[CmdletBinding()] Param()

filter Repair-AppxPackage
{
    [CmdletBinding()] Param(
    [Parameter(ValueFromPipelineByPropertyName=$true)][string] $Name,
    [Parameter(ValueFromPipelineByPropertyName=$true)][string] $Version,
    [Parameter(ValueFromPipelineByPropertyName=$true)][string] $InstallLocation
    )
    try { Add-AppxPackage -DisableDevelopmentMode -Register "$InstallLocation\AppxManifest.xml" -ErrorAction Stop }
    catch { Write-Error "Error repairing '$Name' v$Version`nInstall location: $InstallLocation`n$_" }
}

Get-AppxPackage |Repair-AppxPackage
