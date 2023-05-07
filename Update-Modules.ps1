<#
.SYNOPSIS
Cleans up old modules.

.FUNCTIONALITY
PowerShell Modules
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param()

Update-Module -Force
foreach($module in Get-Module -List |Group-Object Name |Where-Object Count -gt 1)
{
	$newestversion = $module.Group.Version |Sort-Object -Descending |Select-Object -First 1
	foreach($oldmodule in $module.Group |Where-Object Version -lt $newestversion)
	{
		Uninstall-Module $oldmodule.Name -RequiredVersion $oldmodule.Version
	}
}

