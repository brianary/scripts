<#
.Synopsis
    Returns unused web application settings that have accumulated.

.Link
    Get-Website

.Link
    Get-WebApplication

.Link
    Select-XmlNodeValue.ps1

.Example
    Get-IisAppHostCruft.ps1
#>

#Requires -Version 3
#Requires -Module WebAdministration
[CmdletBinding()] Param()
foreach($website in Get-Website)
{
    $name,$path = $website.Name,$website.PhysicalPath
    Select-Xml "/configuration/location[starts-with(@path,'$name/')]/@path" $env:SystemRoot\System32\inetsrv\config\applicationHost.config |
        ? {$app = $_.Node.Value -replace "\A$name/",''; !(Test-Path $path\$app -PathType Container) -and !(Get-WebApplication -Site $name $app)} |
        Select-XmlNodeValue.ps1
}
