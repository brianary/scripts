<#
.SYNOPSIS
Cleans up old modules.

.FUNCTIONALITY
PowerShell Modules

.LINK
Uninstall-OldModules.ps1

.EXAMPLE
Update-Modules.ps1

Updates installed modules and purges old versions.
#>

#Requires -Version 3
[CmdletBinding()] Param()
Update-Module -Force
Uninstall-OldModules.ps1
