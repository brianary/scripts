<#
.Synopsis
	Updates everything it can on the system.

.Link
	Uninstall-OldModules.ps1

.Example
	Update-Everything.ps1

	Attempts to update packages, features, and system.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[CmdletBinding()] Param()

if((Get-Command Get-CimInstance -ErrorAction SilentlyContinue))
{
	Write-Host "$(Get-Unicode.ps1 0x1F199) Updating Windows Store apps" -fore White -back DarkGray
	Get-CimInstance MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root\cimv2\mdm\dmmap |
		Invoke-CimMethod -MethodName UpdateScanMethod
}
if((Get-Command cup -ErrorAction SilentlyContinue))
{
	Write-Host "$(Get-Unicode.ps1 0x1F199) Updating Chocolatey packages" -fore White -back DarkGray
	cup all -y
}
if((Get-Command npm -ErrorAction SilentlyContinue))
{
	Write-Host "$(Get-Unicode.ps1 0x1F199) Updating npm packages" -fore White -back DarkGray
	npm update -g
}
if((Get-Command dotnet -ErrorAction SilentlyContinue))
{
	Write-Host "$(Get-Unicode.ps1 0x1F199) Updating dotnet global tools" -fore White -back DarkGray
	Get-DotNetGlobalTools.ps1 |
		where {$_.Version -lt (Find-DotNetGlobalTools.ps1 $_.PackageName |where PackageName -eq $_.PackageName).Version} |
		foreach {dotnet tool update -g $_.PackageName}
}
Write-Host "$(Get-Unicode.ps1 0x1F199) Updating PowerShell modules" -fore White -back DarkGray
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
	Write-Host "$(Get-Unicode.ps1 0x1F199) Uninstalling old PowerShell modules" -fore White -back DarkGray
	Uninstall-OldModules.ps1 -Force
}
Write-Host "$(Get-Unicode.ps1 0x1F199) Updating PowerShell help" -fore White -back DarkGray
Update-Help
if((Get-Module PSWindowsUpdate -ListAvailable))
{
	Write-Host "$(Get-Unicode.ps1 0x1F199) Updating Windows" -fore White -back DarkGray
	Get-WindowsUpdate
	Install-WindowsUpdate |Format-Table X,Result,KB,Size,Title
}
