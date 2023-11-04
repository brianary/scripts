<#
.SYNOPSIS
Returns the available NuGet configuration files, in order of preference.

.OUTPUTS
System.String containing the path to a NuGet config file.

.FUNCTIONALITY
Configuration

.LINK
https://docs.myget.org/docs/how-to/nuget-configuration-inheritance

.EXAMPLE
Get-NuGetConfigs.ps1

C:\Users\zaphodb\GitHub\ProjectX\src\nuget.config
C:\Users\zaphodb\AppData\Roaming\NuGet\NuGet.config
C:\ProgramData\NuGet\Config.config
C:\ProgramData\NuGet\NuGetDefaults.config
#>

#Requires -Version 7
[CmdletBinding()][OutputType([string])] Param(
# The directory to walk the parents of, to look for configs.
[Parameter(Position=0)][string] $Directory = "$PWD"
)

function Get-Parent([Parameter(Position=0)][string] $Directory)
{
	if($Directory -eq "$(Join-Path (Split-Path $Directory -Qualifier) '')") {$Directory}
	else {$Directory; Get-Parent (Split-Path $Directory)}
}

Get-Parent $Directory |ForEach-Object {Join-Path $_ nuget.config} |Where-Object {Test-Path $_ -Type Leaf}
Join-Path $env:APPDATA NuGet NuGet.config |Where-Object {Test-Path $_ -Type Leaf}
Join-Path $env:ProgramData NuGet Config*.config |Resolve-Path -ErrorAction Ignore |Sort-Object Length -Descending
Join-Path $env:ProgramData NuGet NuGetDefaults.config |Where-Object {Test-Path $_ -Type Leaf}
