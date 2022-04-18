<#
.SYNOPSIS
Return a credential from secure storage, or prompt the user for it if not found.

.OUTPUTS
System.Management.Automation.PSCredential entered by the user, potentially loaded from the cache.

.NOTES
You'll need to have a registered secret vault.

Register-SecretVault Microsoft.PowerShell.SecretStore -name $VaultName [-DefaultVault]

You can control whether the vault prompts for a password using Set-SecretStoreConfiguration

.LINK
https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/

.LINK
ConvertTo-Base64.ps1

.LINK
Stop-ThrowError.ps1

.EXAMPLE
$cred = Get-CachedCredential.ps1 exampleuser 'OpenTV API login'

$cred now contains the login information entered, either this time or from a previous execution.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([pscredential])] Param(
# Specifies a user or account name for the authentication prompt to request a password for.
[Parameter(Position=0,Mandatory=$true)][string] $UserName,
# Provides a login prompt for the user that should be a globally unique description of the purpose of the login.
[Parameter(Position=1,Mandatory=$true)][string] $Message,
<#
The name of the secret vault to retrieve the Pocket API consumer key from.
By default, the default vault is used.
#>
[string] $Vault,
# Indicates that the old-style filesystem-based credential store should be used.
[switch] $UseFile,
# Indicates the login should be manual and overwrite any cached value.
[switch] $Force
)
if($UseFile)
{
	$credcache = Join-Path $env:LOCALAPPDATA .credcache
	if(!(Test-Path $credcache -Type Container)) {mkdir $credcache |Out-Null}
	$hashalg = New-Object Security.Cryptography.SHA256Managed
	$entry = ConvertTo-Base64.ps1 -Data $hashalg.ComputeHash([Text.Encoding]::UTF8.GetBytes("$UserName@$Message")) -UriStyle
	$file = Join-Path $credcache $entry
	if($Force -or !(Test-Path $file -Type Leaf))
	{
		if(!(Test-Interactive.ps1)) {Throw-StopError.ps1 'Credential has not been cached.' -OperationContext $PSBoundParameters}
		$cred = Get-Credential $UserName -Message $Message
		if($cred.UserName -ne $UserName) {Stop-ThrowError.ps1 "Credential is only valid for username $UserName" -OperationContext $cred}
		ConvertFrom-SecureString $cred.Password |Out-File $file
		$cred
	}
	else
	{
		New-Object pscredential $UserName,(Get-Content $file |ConvertTo-SecureString)
	}
}
else
{
	Import-Module Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretStore -Force
	$consumerKey = (New-Object PSCredential $UserName,
		(Get-Secret $UserName -Vault $Vault -ErrorAction SilentlyContinue)).GetNetworkCredential().Password
	if(!$consumerKey)
	{
		$consumerKey = Get-Credential $UserName -Message $Message
		Set-Secret $UserName $consumerKey.Password -Vault $Vault
		$consumerKey = $consumerKey.GetNetworkCredential().Password
	}
}
