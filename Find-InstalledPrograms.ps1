<#
.SYNOPSIS
Searches installed programs.

.OUTPUTS
System.Management.ManagementObject for each program found.

.FUNCTIONALITY
System and updates

.LINK
Get-CimInstance

.LINK
https://serverfault.com/questions/693264/with-powershell-get-exactly-the-same-application-list-as-in-add-remove-programms

.EXAMPLE
Find-InstalledPrograms.ps1 %powershell%

IdentifyingNumber : {B06D1894-3827-4E0C-A092-7DC50BE8B210}
Name              : PowerShell 7-x64
Vendor            : Microsoft Corporation
Version           : 7.4.1.0
Caption           : PowerShell 7-x64
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.ManagementObject])] Param(
# The product name to search for. SQL-style "like" wildcards are supported.
[string] $Name
)
Get-CimInstance CIM_Product -Filter "Name like '$($Name -replace "'","''")'"
