<#
.Synopsis
    Checks whether the current session has administrator privileges.
#>

#Requires -Version 2
([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
	IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
