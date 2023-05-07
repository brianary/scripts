<#
.SYNOPSIS
Imports secrets into secret vaults.

.NOTES
This is likely the configuration you'll need to run this:
Set-SecretStoreConfiguration -Scope CurrentUser -Authentication None -Interaction None

.INPUTS
System.Management.Automation.PSObject with these fields:
* Name: The secret name, used to identify the secret.
* Type: The data type of the secret.
* VaultName: Which vault the secret is stored in.
* Metadata: A simple hash (string to string/int/datetime) of extra secret context details.

.FUNCTIONALITY
Credential

.LINK
https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/

.EXAMPLE
Get-Content ~/secrets.json |ConvertFrom-Json |Import-SecretVault.ps1

Restores secrets to vaults.
#>

#Requires -Version 7
#Requires -Modules Microsoft.PowerShell.SecretStore,Microsoft.PowerShell.SecretManagement
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText','',
Justification='This script exports secrets.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword','',
Justification='This script exports secrets.')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUsernameAndPasswordParams','',
Justification='This script exports secrets.')]
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param(
[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Name,
[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Type,
[Parameter(ValueFromPipelineByPropertyName=$true)][psobject] $Value,
[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Vault,
[Parameter(ValueFromPipelineByPropertyName=$true)][psobject] $Metadata
)
Begin
{
	filter ConvertTo-Credential
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipelineByPropertyName=$true)][string] $UserName,
		[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Password
		)
		return New-Object PSCredential $UserName,(ConvertTo-SecureString $Password -AsPlainText -Force)
	}
}
Process
{
	if(!(Get-SecretVault $Vault -ErrorAction Ignore))
	{
		Register-SecretVault -Name $Vault -ModuleName Microsoft.PowerShell.SecretStore
	}
	$meta = @($Metadata.PSObject.Properties).Count ? @{Metadata=ConvertTo-OrderedDictionary.ps1 $Metadata} : @{}
	foreach($k in $meta.Keys) {if($meta[$k] -is [long]){$meta[$k] = [int]$meta[$k]}}
	switch($Type)
	{
		ByteArray {Set-Secret $Name ([Convert]::FromHexString($Value)) -Vault $Vault @meta}
		String {Set-Secret $Name $Value -Vault $Vault @meta}
		SecureString {Set-Secret $Name (ConvertTo-SecureString $Value -AsPlainText -Force) -Vault $Vault @meta}
		PSCredential {Set-Secret $Name ($Value |ConvertTo-Credential) -Vault $Vault @meta}
		Hashtable {Set-Secret $Name (ConvertTo-OrderedDictionary.ps1 $Value) -Vault $Vault @meta} # not yet supported
		default {Set-Secret $Name $Value -Vault $Vault @meta}
	}
}
