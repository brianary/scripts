<#
.SYNOPSIS
Returns the scope of an installed module.

.FUNCTIONALITY
PowerShell Modules

.INPUTS
System.Object with a "Name" or "ModuleName" property containing a module name.

.OUTPUTS
System.Management.Automation.PSObject with the following properties:
* ModuleName: The name of the module.
* Scope: The value "CurrentUser" if the module is found within $HOME\Documents\PowerShell\Modules, "AllUsers" if found anywhere else.

.EXAMPLE
Get-ModuleScope.ps1 Detextive

ModuleName Scope
---------- -----
Detextive  CurrentUser

.EXAMPLE
Get-ModuleScope.ps1 Pester

ModuleName Scope
---------- -----
Pester     CurrentUser
Pester     AllUsers
#>

#Requires -Version 7
[CmdletBinding()][OutputType([string])] Param(
# Specifies names or name patterns of modules that this cmdlet gets. Wildcard characters are permitted.
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)][Alias('ModuleName')][string] $Name = '*'
)
Begin
{
    $UserRoot = Join-Path $HOME Documents PowerShell Modules
}
Process
{
    foreach($moduleName in Get-Module $Name -ListAvailable |Select-Object -ExpandProperty Name -Unique)
    {
        Get-Module $moduleName -ListAvailable |
            Select-Object -ExpandProperty ModuleBase |
            Split-Path |
            Split-Path |
            Select-Object -Unique |
            ForEach-Object {$_ -eq $UserRoot ? 'CurrentUser' : 'AllUsers'} |
            Select-Object -Unique |
            ForEach-Object {[pscustomobject]@{ModuleName=$moduleName;Scope=$_}}
    }
}
