<#
.SYNOPSIS
Searches installed programs.

.OUTPUTS
System.Management.ManagementObject for each program found.

.LINK
Get-CimInstance

.LINK
https://serverfault.com/questions/693264/with-powershell-get-exactly-the-same-application-list-as-in-add-remove-programms

.EXAMPLE
Find-InstalledPrograms.ps1 %powershell%

IdentifyingNumber : {65276649-728D-4AB9-AAEC-6EFF860B11EC}
Name              : PowerShell 6-x64
Vendor            : Microsoft Corporation
Version           : 6.1.2.0
Caption           : PowerShell 6-x64
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.ManagementObject])] Param(
# The product name to search for. SQL-style "like" wildcards are supported.
[string] $Name
)
Get-CimInstance CIM_Product -Filter "Name like '$($Name -replace "'","''")'"
