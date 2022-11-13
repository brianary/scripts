<#
.SYNOPSIS
Updates everything it can on the system.

.LINK
https://docs.microsoft.com/windows/package-manager/winget/

.LINK
https://github.com/microsoft/winget-cli

.LINK
https://www.microsoft.com/store/apps/windows

.LINK
https://powershellgallery.com/

.LINK
https://chocolatey.org/

.LINK
https://npmjs.com/

.LINK
https://docs.microsoft.com/dotnet/core/tools/global-tools

.LINK
https://www.dell.com/support/kbdoc/000177325/dell-command-update

.LINK
Update-Everything.cmd

.LINK
Uninstall-OldModules.ps1

.LINK
Get-DotNetGlobalTools.ps1

.LINK
Find-DotNetGlobalTools.ps1

.LINK
Get-Process

.LINK
Stop-Process

.LINK
Start-Process

.LINK
ConvertFrom-Csv

.LINK
Get-CimInstance

.LINK
Invoke-CimMethod

.LINK
Get-Module

.LINK
Find-Module

.LINK
Update-Module

.LINK
Update-Help

.LINK
Get-WindowsUpdate

.LINK
Install-WindowsUpdate

.EXAMPLE
Update-Everything.ps1

Attempts to update packages, features, and system.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost','',
Justification='This script is not intended for pipelining.')]
[CmdletBinding()] Param(
# The sources of updates to install, in order.
[ValidateSet('Chocolatey','DellCommand','Dotnet','Essentials','Npm','PSHelp',
	'PSModules','Scoop','Windows','WindowsStore','WinGet')]
[Parameter(Position=0,ValueFromRemainingArguments=$true)][string[]] $Steps =
	@('Essentials','WindowsStore','Scoop','Chocolatey','WinGet','Npm','Dotnet',
		'PSModules','PSHelp','DellCommand','Windows')
)
Begin
{
	Set-Variable 'UP!' "$([char]0xD83C)$([char]0xDD99)" -Option Constant -Scope Script -Description 'UP! symbol'

	function Write-Step([string]$Message)
	{
		Write-Host $Message -ForegroundColor White -BackgroundColor DarkGray
	}

	function Invoke-EssentialUpdates
	{
		Write-Step "${UP!} Updating PowerShell & Windows Terminal"
		Get-Process powershell -ErrorAction Ignore |Where-Object Id -ne $PID |Stop-Process -Force
		Get-Process pwsh -ErrorAction Ignore |Where-Object Id -ne $PID |Stop-Process -Force
		Start-Process ([io.path]::ChangeExtension($PSCommandPath,'cmd')) -Verb RunAs -WindowStyle Maximized
		$host.SetShouldExit(0)
		exit
	}

	function Update-Essentials
	{
		Write-Step "$([char]0xD83D)$([char]0xDD1C) Checking for essential updates"
		if(Get-Command choco -ErrorAction Ignore)
		{
			if(choco outdated -r |
				ConvertFrom-Csv -Delimiter '|' -Header PackageName,LocalVersion,AvailableVersion |
				Where-Object PackageName -in powershell,powershell-core,microsoft-windows-terminal)
			{Invoke-EssentialUpdates}
		}
		elseif(Get-Command winget -ErrorAction Ignore)
		{
			if(@(winget list Microsoft.WindowsTerminal |
				Select-Object -Skip 2 -First 1 |
				Select-String Available &&
				winget list Microsoft.PowerShell |
				Select-Object -Skip 2 -First 1 |
				Select-String Available).Count -gt 0)
			{Invoke-EssentialUpdates}
		}
		else
		{
			Write-Verbose 'Neither Chocolatey nor WinGet found, skipping essential updates'
		}
	}

	function Update-WindowsStore
	{
		if(!(Get-Command Get-CimInstance -ErrorAction Ignore))
		{Write-Verbose 'Get-CimInstance not found, skipping WindowsStore updates'; return}
		Write-Step "${UP!} Updating Windows Store apps (asynchronously)"
		Get-CimInstance MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root\cimv2\mdm\dmmap |
			Invoke-CimMethod -MethodName UpdateScanMethod
	}

	function Update-Scoop
	{
		if(!(Get-Command scoop -ErrorAction Ignore))
		{Write-Verbose 'Scoop not found, skipping'; return}
		Write-Step "${UP!} Updating Scoop packages"
		scoop update *
	}

	function Update-Chocolatey
	{
		if(!(Get-Command choco -ErrorAction Ignore))
		{Write-Verbose 'Chocolatey not found, skipping'; return}
		Write-Step "${UP!} Updating Chocolatey packages"
		choco upgrade all -y
	}

	function Update-WinGet
	{
		if(!(Get-Command winget -ErrorAction Ignore))
		{Write-Verbose 'WinGet not found, skipping'; return}
		Write-Step "${UP!} Updating WinGet packages"
		winget upgrade --all
	}

	function Update-Npm
	{
		if(!(Get-Command npm -ErrorAction Ignore))
		{Write-Verbose 'Npm not found, skipping'; return}
		Write-Step "${UP!} Updating npm packages"
		npm update -g
	}

	function Update-Dotnet
	{
		if(!(Get-Command dotnet -ErrorAction Ignore))
		{Write-Verbose 'Dotnet not found, skipping'; return}
		Write-Step "${UP!} Updating dotnet global tools"
		& "$PSScriptRoot\Get-DotNetGlobalTools.ps1" |
			Where-Object {
				$_.Version -lt (& "$PSScriptRoot\Find-DotNetGlobalTools.ps1" $_.PackageName |
					Where-Object PackageName -eq $_.PackageName).Version
			} |
			ForEach-Object {dotnet tool update -g $_.PackageName}
	}

	function Update-PSModules
	{
		Write-Step "${UP!} Updating PowerShell modules"
		Get-Module -ListAvailable |
			Group-Object Name |
			Where-Object {
				$found = Find-Module $_.Name -ErrorAction Ignore
				if(!$found) {return $false}
				($_.Group |Measure-Object Version -Maximum).Maximum -lt [version]$found.Version
			} |
			Update-Module -Force
		if(Get-Command Uninstall-OldModules.ps1 -ErrorAction Ignore)
		{
			Write-Step "${UP!} Uninstalling old PowerShell modules"
			Uninstall-OldModules.ps1 -Force
		}
	}

	function Update-PSHelp
	{
		Write-Step "${UP!} Updating PowerShell help"
		Update-Help
	}

	function Update-DellCommand
	{
		if(!(Resolve-Path "C:\Program Files*\Dell\CommandUpdate\dcu-cli.exe"))
		{Write-Verbose 'Dell Command not found, skipping'; return}
		Write-Step "${UP!} Updating Dell firmware & system software"
		Set-Alias dcu-cli "$(Resolve-Path "C:\Program Files*\Dell\CommandUpdate\dcu-cli.exe")"
		dcu-cli /scan
		if($LASTEXITCODE -ne 500) {dcu-cli /applyUpdates -reboot=enable}
		Write-Host ''
	}

	function Update-Windows
	{
		if(!(Get-Module PSWindowsUpdate -ListAvailable))
		{Write-Verbose 'PSWindowsUpdate module not found, skipping Windows Updates'; return}
		Write-Step "${UP!} Updating Windows"
		Get-WindowsUpdate
		Install-WindowsUpdate |Format-Table X,Result,KB,Size,Title
	}
}

Process {$Steps |ForEach-Object {& "Update-$_"}}
