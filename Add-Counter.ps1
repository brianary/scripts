<#
.SYNOPSIS
Adds an incrementing integer property to each pipeline object.

.DESCRIPTION
If you want to add a quick index property to objects in a pipeline, this does that.

.INPUTS
System.Management.Automation.PSObject item to add an index property to.

.OUTPUTS
System.Management.Automation.PSObject with the added index property.

.FUNCTIONALITY
PowerShell

.LINK
Add-Member

.EXAMPLE
Get-PSProvider |Add-Counter Position |select Name,Position

Name        Position
----        --------
Registry           1
Alias              2
Environment        3
FileSystem         4
Function           5
Variable           6
Certificate        7
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject])] Param(
# The name of the property to add.
[Parameter(Position=0)][string] $PropertyName = 'Counter',
# The starting number to count from.
[Parameter(Position=1)][int] $InitialValue = 1,
# The object to add the property to.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][psobject] $InputObject,
# Overwrites a property if one with the same name already exists.
[switch] $Force
)
Begin { $i = $InitialValue }
Process { Add-Member $PropertyName ($i++) -InputObject $InputObject -PassThru -Force:$Force }
