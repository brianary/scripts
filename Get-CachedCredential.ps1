<#
.Synopsis
    Return a credential from secure storage, or prompt the user for it if not found.

.Parameter UserName
    Specifies a user or account name for the authentication prompt to request a password for.

.Parameter Message
    Provides a login prompt for the user that should be a globally unique description of the purpose of the login.

.Parameter Force
    Indicates the login should be manual and overwrite any cached value.

.Outputs
    System.Management.Automation.PSCredential entered by the user, potentially loaded from the cache.

.Link
    ConvertTo-Base64.ps1

.Link
    Stop-ThrowError.ps1

.Example
    $cred = Get-CachedCredential.ps1 exampleuser 'OpenTV API login'

    $cred now contains the login information entered, either this time or from a previous execution.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([pscredential])] Param(
[Parameter(Position=0,Mandatory=$true)][string] $UserName,
[Parameter(Position=1,Mandatory=$true)][string] $Message,
[switch] $Force
)
$credcache = Join-Path $env:LOCALAPPDATA .credcache
if(!(Test-Path $credcache -Type Container)) {mkdir $credcache |Out-Null}
$hashalg = New-Object Security.Cryptography.SHA256Managed
$entry = ConvertTo-Base64.ps1 -Data $hashalg.ComputeHash([Text.Encoding]::UTF8.GetBytes("$UserName@$Message")) -UriStyle
$file = Join-Path $credcache $entry
if($Force -or !(Test-Path $file -Type Leaf))
{
    $cred = Get-Credential $UserName -Message $Message
    if($cred.UserName -ne $UserName) {Stop-ThrowError.ps1 "Credential is only valid for username $UserName" -OperationContext $cred}
    ConvertFrom-SecureString $cred.Password |Out-File $file
    $cred
}
else
{
    New-Object pscredential $UserName,(Get-Content $file |ConvertTo-SecureString)
}
