<#
.SYNOPSIS
Removes a credential from secure storage.

.FUNCTIONALITY
Credential

.LINK
ConvertTo-Base64.ps1

.LINK
Stop-ThrowError.ps1

.EXAMPLE
Remove-CachedCredential.ps1 exampleuser 'OpenTV API login'

The credential is removed from secure storage.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([pscredential])] Param(
# Specifies a user or account name that was used to create the credential.
[Parameter(Position=0,Mandatory=$true)][string] $UserName,
# Provides a login prompt for the user that should be a globally unique description of the purpose of the login.
[Parameter(Position=1,Mandatory=$true)][string] $Message
)
$credcache = Join-Path $env:LOCALAPPDATA .credcache
if(!(Test-Path $credcache -Type Container)) {return}
$hashalg = New-Object Security.Cryptography.SHA256Managed
$entry = ConvertTo-Base64.ps1 -Data $hashalg.ComputeHash([Text.Encoding]::UTF8.GetBytes("$UserName@$Message")) -UriStyle
$file = Join-Path $credcache $entry
if(Test-Path $file -Type Leaf) {Remove-Item $file -Force}

