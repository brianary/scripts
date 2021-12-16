<#
.Synopsis
	Updates all packages it can.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[CmdletBinding()] Param()

if((Get-Command Get-CimInstance -ErrorAction SilentlyContinue))
{
	Write-Host 'Updating Windows Store apps' -Fore DarkYellow
	Get-CimInstance MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root\cimv2\mdm\dmmap |
		Invoke-CimMethod -MethodName UpdateScanMethod
}
if((Get-Command cup -ErrorAction SilentlyContinue))
{
	Write-Host 'Updating Chocolatey packages' -Fore DarkYellow
	cup all -y
}
if((Get-Command npm -ErrorAction SilentlyContinue))
{
	Write-Host 'Updating npm packages' -Fore DarkYellow
	npm update -g
}
if((Get-Command dotnet -ErrorAction SilentlyContinue))
{
	Write-Host 'Updating dotnet global tools' -Fore DarkYellow
	Get-DotNetGlobalTools.ps1 |foreach {dotnet tool update -g $_.Package}
}
Write-Host 'Updating PowerShell help' -Fore DarkYellow
Update-Help
if((Get-Module PSWindowsUpdate -ListAvailable))
{
	Write-Host 'Updating Windows' -Fore DarkYellow
	Get-WindowsUpdate
	Install-WindowsUpdate |Format-Table X,Result,KB,Size,Title
}
