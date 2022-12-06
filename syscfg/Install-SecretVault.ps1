<#
.SYNOPSIS
Installs the infrastructure for storing secrets.

.FUNCTIONALITY
System and updates

.EXAMPLE
Install-SecretVault.ps1

Installs modules and sets up the vault.
#>

#Requires -Version 3
[CmdletBinding()] Param()

if(!(Get-Module Microsoft.PowerShell.SecretManagement -ListAvailable))
{
	Install-Module Microsoft.PowerShell.SecretManagement -Force
}
if(!(Get-Module Microsoft.PowerShell.SecretStore -ListAvailable))
{
	Install-Module Microsoft.PowerShell.SecretStore -Force
}
Reset-SecretStore -Authentication None -Interaction None -Force:$(!(Get-SecretInfo))
Register-SecretVault Microsoft.PowerShell.SecretStore -Name SecretStore -DefaultVault
Set-SecretVaultDefault SecretStore
if((Test-SecretVault SecretStore)) {Write-Info.ps1 'SecretVault installed successfully' -fg Green}
else {Write-Info.ps1 'SecretVault installation failed' -fg Red}
