<#
.Synopsis
	Searches installed programs.

.Parameter Name
	The product name to search for. SQL-style "like" wildcards are supported.

.Outputs
	System.Management.ManagementObject for each program found.

.Link
	Get-CimInstance

.Link
	https://serverfault.com/questions/693264/with-powershell-get-exactly-the-same-application-list-as-in-add-remove-programms

.Example
	Find-InstalledPrograms.ps1 %powershell%

	IdentifyingNumber : {65276649-728D-4AB9-AAEC-6EFF860B11EC}
	Name              : PowerShell 6-x64
	Vendor            : Microsoft Corporation
	Version           : 6.1.2.0
	Caption           : PowerShell 6-x64
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.ManagementObject])] Param(
[string] $Name
)
Get-CimInstance Win32_Product -Filter "Name like '$($Name -replace "'","''")'"
