<#
.SYNOPSIS
Returns the current login properties of an ActiveDirectory user.

.LINK
https://learn.microsoft.com/powershell/module/activedirectory/get-aduser

.LINK
Invoke-WindowsPowerShell.ps1

.LINK
Get-ADUser

.EXAMPLE
Get-ADUserStatus.ps1 alans

PasswordExpires        : 07/17/2023 12:01:01 AM
BadLogonsRemaining     : 5
AccountExpirationDate  :
AccountExpires         : 9223372036854775807
AccountLockoutTime     :
BadLogonCount          : 0
BadPwdCount            : 0
DistinguishedName      : CN=Alan Smithee,OU=Directors,DC=example,DC=local
Enabled                : True
GivenName              : Alan
LastBadPasswordAttempt : 04/17/2023 2:16:20 PM
LastLogonDate          : 04/12/2023 5:07:55 PM
LockedOut              : False
Name                   : Alan Smithee
ObjectClass            : user
ObjectGUID             : 0a2e6b9c-83d5-466b-b45b-69d6fe626b08
PasswordExpired        : False
PasswordLastSet        : 04/18/2023 12:01:01 AM
PwdLastSet             : 133262748613029225
SamAccountName         : alans
SID                    : S-1-5-21-3351665499-1662801859-681883470-29151
Surname                : Smithee
UserPrincipalName      : alans@example.local
#>

#Requires -Version 7
#Requires -Modules ActiveDirectory
[CmdletBinding()][OutputType([Microsoft.ActiveDirectory.Management.ADUser])] Param(
[Parameter(Position=0,Mandatory=$true)][Microsoft.ActiveDirectory.Management.ADUser] $Identity
)
$policy = Get-ADDefaultDomainPasswordPolicy
return Get-ADUser -Identity $Identity -Properties AccountExpirationDate, AccountExpires, AccountLockoutTime, BadLogonCount,
	BadPwdCount, LastBadPasswordAttempt, LastLogonDate, LockedOut, PasswordExpired, PasswordLastSet, PwdLastSet |
	Add-NoteProperty.ps1 PasswordExpires {$_.PasswordLastSet + $policy.MaxPasswordAge} -Force -PassThru |
	Add-NoteProperty.ps1 BadLogonsRemaining {$policy.LockoutThreshold - $_.BadLogonCount} -Force -PassThru
