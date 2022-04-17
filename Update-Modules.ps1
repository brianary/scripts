<#
.SYNOPSIS
Cleans up old modules.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param()

Update-Module -Force
foreach($module in Get-Module -List |group Name |where Count -gt 1)
{
	$newestversion = $module.Group.Version |sort -Descending |select -First 1
	foreach($oldmodule in $module.Group |where Version -lt $newestversion)
	{
		Uninstall-Module $oldmodule.Name -RequiredVersion $oldmodule.Version
	}
}
