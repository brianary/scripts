<#
.SYNOPSIS
Checks whether the current session has administrator privileges.

.FUNCTIONALITY
PowerShell

.EXAMPLE
Test-Administrator.ps1

False
#>

#Requires -Version 2
if($IsWindows)
{
	return ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
		IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
else {return [Environment]::IsPrivilegedProcess}
