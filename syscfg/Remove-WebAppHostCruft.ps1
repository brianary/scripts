<#
.Synopsis
    Removes unused web application settings that have accumulated.

.Link
    Get-Website

.Link
    Get-WebApplication

.Link
    Remove-Xml.ps1

.Example
    Remove-WebAppHostCruft.ps1 -WhatIf

    Shows what settings would be removed.
#>

#Requires -Version 3
#Requires -Module WebAdministration
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')][OutputType([void])] Param()
foreach($website in Get-Website)
{
    $name,$path = $website.Name,$website.PhysicalPath
    Select-Xml "/configuration/location[starts-with(@path,'$name/')]" $env:SystemRoot\System32\inetsrv\config\applicationHost.config |
        ? {$app = $_.Node.Attributes['path'].Value -replace "\A$name/",''; !(Test-Path $path\$app -PathType Container) -and !(Get-WebApplication -Site $name $app)} |
        ? {$PSCmdlet.ShouldProcess($_.Node.Attributes['path'].Value,'remove')} |
        Remove-Xml.ps1 -Verbose
}
