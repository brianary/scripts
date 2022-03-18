<#
.Synopsis
	Updates everything it can on the system.

.Link
	https://www.microsoft.com/en-us/store/apps/windows

.Link
	https://powershellgallery.com/

.Link
	https://chocolatey.org/

.Link
	https://npmjs.com/

.Link
	https://docs.microsoft.com/dotnet/core/tools/global-tools

.Link
	https://www.dell.com/support/kbdoc/000177325/dell-command-update

.Link
	Update-Everything.cmd

.Link
	Uninstall-OldModules.ps1

.Link
	Get-DotNetGlobalTools.ps1

.Link
	Find-DotNetGlobalTools.ps1

.Link
	Get-Process

.Link
	Stop-Process

.Link
	Start-Process

.Link
	ConvertFrom-Csv

.Link
	Get-CimInstance

.Link
	Invoke-CimMethod

.Link
	Get-Module

.Link
	Find-Module

.Link
	Update-Module

.Link
	Update-Help

.Link
	Get-WindowsUpdate

.Link
	Install-WindowsUpdate

.Example
	Update-Everything.ps1

	Attempts to update packages, features, and system.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[CmdletBinding()] Param()

${UP!} = "$([char]0xD83C)$([char]0xDD99)"
$hoststatus = @{ForegroundColor='White';BackgroundColor='DarkGray'}
Write-Host "$([char]0xD83D)$([char]0xDD1C) Checking for shell updates" @hoststatus
if((choco outdated -r |
	ConvertFrom-Csv -Delimiter '|' -Header PackageName,LocalVersion,AvailableVersion |
	where PackageName -in powershell,powershell-core,microsoft-windows-terminal))
{
	Write-Host "${UP!} Updating PowerShell & Windows Terminal" @hoststatus
	Get-Process powershell -ErrorAction SilentlyContinue |where Id -ne $PID |Stop-Process -Force
	Get-Process pwsh -ErrorAction SilentlyContinue |where Id -ne $PID |Stop-Process -Force
	Start-Process ([io.path]::ChangeExtension($PSCommandPath,'cmd')) -Verb RunAs -WindowStyle Maximized
	$host.SetShouldExit(0)
	exit
}
if((Get-Command Get-CimInstance -ErrorAction SilentlyContinue))
{
	Write-Host "${UP!} Updating Windows Store apps" @hoststatus
	Get-CimInstance MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root\cimv2\mdm\dmmap |
		Invoke-CimMethod -MethodName UpdateScanMethod
}
if((Get-Command cup -ErrorAction SilentlyContinue))
{
	Write-Host "${UP!} Updating Chocolatey packages" @hoststatus
	cup all -y
}
if((Get-Command npm -ErrorAction SilentlyContinue))
{
	Write-Host "${UP!} Updating npm packages" @hoststatus
	npm update -g
}
if((Get-Command dotnet -ErrorAction SilentlyContinue))
{
	Write-Host "${UP!} Updating dotnet global tools" @hoststatus
	& "$PSScriptRoot\Get-DotNetGlobalTools.ps1" |
		where {
			$_.Version -lt (& "$PSScriptRoot\Find-DotNetGlobalTools.ps1" $_.PackageName |
				where PackageName -eq $_.PackageName).Version
		} |
		foreach {dotnet tool update -g $_.PackageName}
}
Write-Host "${UP!} Updating PowerShell modules" @hoststatus
Get-Module -ListAvailable |
	group Name |
	where {
		$found = Find-Module $_.Name -ErrorAction SilentlyContinue
		if(!$found) {return $false}
		($_.Group |measure Version -Maximum).Maximum -lt [version]$found.Version
	} |
	Update-Module -Force
if((Get-Command Uninstall-OldModules.ps1 -ErrorAction SilentlyContinue))
{
	Write-Host "${UP!} Uninstalling old PowerShell modules" @hoststatus
	Uninstall-OldModules.ps1 -Force
}
Write-Host "${UP!} Updating PowerShell help" @hoststatus
Update-Help
if(Test-Path "$env:ProgramFiles\Dell\CommandUpdate\dcu-cli.exe" -Type Leaf)
{
	Write-Host "${UP!} Updating Dell firmware & system software" @hoststatus
	Set-Alias dcu-cli "$env:ProgramFiles\Dell\CommandUpdate\dcu-cli.exe"
	dcu-cli /scan
	if($LASTEXITCODE -ne 500) {dcu-cli /applyUpdates -reboot=enable}
	Write-Host ''
}
if((Get-Module PSWindowsUpdate -ListAvailable))
{
	Write-Host "${UP!} Updating Windows" @hoststatus
	Get-WindowsUpdate
	Install-WindowsUpdate |Format-Table X,Result,KB,Size,Title
}
