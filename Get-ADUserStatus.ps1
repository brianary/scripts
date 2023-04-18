<#
.SYNOPSIS
Returns the current login properties of an ActiveDirectory user.

.LINK
Invoke-WindowsPowerShell.ps1

.LINK
Get-ADUser
#>

#Requires -Version 7
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Identity
)
Invoke-WindowsPowerShell.ps1 {
	Param([string] $Identity)
	Import-Module ActiveDirectory
	Get-ADUser -Identity $Identity -properties AccountExpirationDate, AccountExpires, AccountLockoutTime, BadLogonCount,
	PadPwdCount, LastBadPasswordAttempt, LastLogonDate, LockedOut, PasswordExpired, PasswordLastSet, PwdLastSet
} -BlockArgs $Identity
