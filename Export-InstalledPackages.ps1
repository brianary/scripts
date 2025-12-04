<#
.SYNOPSIS
Exports the list of packages installed by various tools.

.FUNCTIONALITY
System and updates

.LINK
https://powershellgallery.com/

.LINK
https://manpages.debian.org/trixie/apt/apt.8.en.html

.LINK
https://pacman.archlinux.page/

.LINK
https://docs.microsoft.com/windows/package-manager/winget/

.LINK
https://chocolatey.org/

.LINK
https://scoop.sh/

.LINK
https://npmjs.com/

.LINK
https://docs.microsoft.com/dotnet/core/tools/global-tools

.LINK
https://cli.github.com/

.EXAMPLE
Export-InstalledPackages.ps1 |ConvertTo-Json |Out-File ~/installed.json utf8

Exports all known packages.
#>

#Requires -Version 7
[CmdletBinding()] Param()

function Test-Command
{
	[CmdletBinding()] Param(
	[Parameter(Position=0,Mandatory=$true)][string] $Name
	)
	return [bool](Get-Command $Name -ErrorAction Ignore)
}

$installed = @{psmodules = Get-Module -ListAvailable |Select-Object -Unique -ExpandProperty Name}

if(Test-Command apt)
{
	$installed['apt'] = apt list --installed
}
if(Test-Command pacman)
{
	$installed['pacman'] = pacman -Qe
}
if(Test-Command winget)
{
	winget export -o "$env:temp\winget.json" |Out-Null
	$winget = Get-Content "$env:temp\winget.json" |ConvertFrom-Json
	$installed['winget'] = @($winget.Sources.Packages.PackageIdentifier)
}
if(Test-Command choco)
{
	$installed['choco'] = @(choco list -l --idonly |Select-Object -Skip 1 |Select-Object -SkipLast 1)
}
if(Test-Command scoop)
{
	$installed['scoop-buckets'] = @(scoop bucket list |Select-Object -ExpandProperty Name)
	$installed['scoop'] = @(scoop list |Select-Object -ExpandProperty Name)
}
if(Test-Command npm)
{
	$installed['npm'] = @(npm list -g --json |
		ConvertFrom-Json -AsHashtable |
		Select-Object -ExpandProperty  dependencies |
		Select-Object -ExpandProperty Keys)
}
if(Test-Command dotnet)
{
	$installed['dotnet-tools'] = @(dotnet tool list -g |Select-Object -Skip 2 |ForEach-Object {($_ -split '\s+',2)[0]})
}
if(Test-Command gh)
{
	$installed['gh-extensions'] = @(gh extension list |ForEach-Object {($_ -split '\s+',4)[2]})
}
if(Test-Command code)
{
	$installed['vscode-extensions'] = @(code --list-extensions)
}

Write-Warning "The exported packages are a verbose list that will probably require editing."
return $installed
