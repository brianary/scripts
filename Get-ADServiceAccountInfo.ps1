<#
.SYNOPSIS
Lists the Global Managed Service Accounts for the domain, including the computers they are bound to.

.EXAMPLE
Get-ADServiceAccountInfo.ps1 |Format-Table -AutoSize

Name     HostComputers LastLogonDate       Description Account
----     ------------- -------------       ----------- -------
service1 SERVERA       2023-08-27 11:14:19 First MSA   {}
service2 SERVERB       2023-08-27 10:27:03 Second MSA  {}
serivce3 SERVERC       2023-08-25 17:19:49 Third MSA   {}
#>

#Requires -Modules ActiveDirectory
[CmdletBinding()] Param(
[Parameter(Position=0)][string] $Filter = '*'
)
Get-ADServiceAccount -Filter $Filter -Properties Description,LastLogonDate,HostComputers |
	ForEach-Object {[pscustomobject]@{
		Name          = $_.Name
		HostComputers = $_.HostComputers |
			ForEach-Object {Get-ADComputer $_} |
			Select-Object -ExpandProperty Name
		LastLogonDate = $_.LastLogonDate
		Description   = $_.Description
		Account       = $_
	}}
