<#
.SYNOPSIS
Restores various configuration files and exported settings from a ZIP file.

.LINK
Import-EdgeKeywords.ps1

.LINK
Import-SecretVault.ps1

.EXAMPLE
Restore-Workstation.ps1 COMPUTERNAME-20230304T125000.zip

Restores various settings from a backup file.
#>

#Requires -Version 7
[CmdletBinding()] Param(
[ValidateScript({Test-Path $_ -Type Leaf})][Parameter(Position=0,Mandatory=$true)][string] $Path
)

function Restore-Workstation
{
	Expand-Archive -Path $Path -DestinationPath ~ -Force
	Join-Path ~ edge-keywords.json -OutVariable file |Get-Content |ConvertFrom-Json |Import-EdgeKeywords.ps1
	Remove-Item $file
	Join-Path ~ secret-vault.json -OutVariable file |Get-Content |ConvertFrom-Json |Import-SecretVault.ps1
	Remove-Item $file
}

Restore-Workstation
