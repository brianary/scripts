<#
.SYNOPSIS
Returns a list of modules that have upgrades available.

.FUNCTIONALITY
PowerShell Modules

.LINK
Get-ModuleScope.ps1

.EXAMPLE
Get-OutdatedModules.ps1

Name       Scope    CurrentVersion  AvailableVersion
---------- -------- --------------- ----------------
PSReadLine AllUsers 2.3.6           2.4.5
ThreadJob  AllUsers 2.0.7           2.1.0
#>

#Requires -Version 7
[CmdletBinding()] Param()
Get-Module -ListAvailable |
    Group-Object Name |
    ForEach-Object -Parallel {
        $name, $group = $_.Name, $_.Group
        try
        {[pscustomobject]@{
            Name             = $name
            Scope            = Get-ModuleScope.ps1 $name |Select-Object -ExpandProperty Scope
            CurrentVersion   = $group |Measure-Object Version -Maximum |Select-Object -ExpandProperty Maximum
            AvailableVersion = Find-Module $name -ErrorAction Stop |Select-Object -ExpandProperty Version
        }}
        catch{}
    } |
    Where-Object {$_.CurrentVersion -lt $_.AvailableVersion}
