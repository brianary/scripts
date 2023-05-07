<#
.SYNOPSIS
Exports secret vault content.

.OUTPUTS
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
Export-SecretVault.ps1 |ConvertTo-Json |Out-File ~/secrets.json utf8

Backs up all secrets to a JSON file.
#>

#Requires -Version 7
#Requires -Modules Microsoft.PowerShell.SecretManagement
[CmdletBinding(ConfirmImpact='High',SupportsShouldProcess=$true)] Param()

filter Export-Credential
{
	[CmdletBinding()][OutputType([pscustomobject])] Param(
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $UserName,
	[Parameter(ValueFromPipelineByPropertyName=$true)][securestring] $Password
	)
	return [pscustomobject]@{
		UserName = $UserName
		Password = $Password |ConvertFrom-SecureString -AsPlainText
	}
}

filter Export-Secret
{
	[CmdletBinding()][OutputType([pscustomobject])] Param(
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Name,
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Type,
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $VaultName,
	[Parameter(ValueFromPipelineByPropertyName=$true)]
	[Collections.ObjectModel.ReadOnlyDictionary[string,object]] $Metadata
	)
	return [pscustomobject]@{
		Name = $Name
		Type = $Type
		Value = switch($Type)
		{
			ByteArray {[Convert]::ToHexString((Get-Secret $Name -Vault $VaultName))}
			String {Get-Secret $Name -Vault $VaultName -AsPlainText}
			SecureString {Get-Secret $Name -Vault $VaultName -AsPlainText}
			PSCredential {Get-Secret $Name -Vault $VaultName |Export-Credential}
			Hashtable {Get-Secret $Name -Vault $VaultName -AsPlainText} # not yet supported
			default {Get-Secret $Name -Vault $VaultName -AsPlainText}
		}
		Vault = $VaultName
		Metadata = $Metadata
	}
}

if(!$PSCmdlet.ShouldProcess('secret vaults','export')) {return}
return @(Get-SecretInfo |Export-Secret)

