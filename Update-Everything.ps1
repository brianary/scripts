<#
.Synopsis
	Updates all packages it can.
#>

#Requires -Version 3
#Requires -RunAsAdministrator
[CmdletBinding()] Param()

if((Get-Command cup -ErrorAction SilentlyContinue)) {Write-Verbose 'Chocolatey updates'; cup all -y}
if((Get-Command npm -ErrorAction SilentlyContinue)) {Write-Verbose 'npm updates'; npm update -g}
if((Get-Command dotnet -ErrorAction SilentlyContinue))
{
	Write-Verbose 'dotnet global tools updates'
	Get-DotNetGlobalTools.ps1 |foreach {dotnet tool update -g $_.Package}
}
