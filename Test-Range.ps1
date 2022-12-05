<#
.SYNOPSIS
Returns true from an initial condition until a terminating condition; a latching test.

.INPUTS
Any object to test.

.OUTPUTS
System.Boolean, or the input object if -Filter is specified.

.FUNCTIONALITY
PowerShell

.EXAMPLE
Get-Item *.ps1 |Test-Range.ps1 {$_.Name -like 'Join-*.ps1'} {$_.Name -like 'New-*.ps1'} -Filter |select Name

Name
----
Join-FileName.ps1
Join-Keys.ps1
Measure-DbColumn.ps1
Measure-DbColumnValues.ps1
Measure-DbTable.ps1
Measure-Indents.ps1
Measure-StandardDeviation.ps1
Measure-TextFile.ps1
Merge-Json.ps1
Merge-PSObject.ps1
Merge-XmlSelections.ps1
#>

#Requires -Version 3
[CmdletBinding()] Param(
<#
Latch: The initial condition which will begin the matching range.
Inclusive: Includes the input object that this condition evaluates a true value for.
#>
[Parameter(Position=0)][scriptblock] $After = {$true},
<#
Unlatch: The terminating condition for the matching range.
Exclusive: Excludes the input object that this condition evaluates a true value for.
#>
[Parameter(Position=1)][scriptblock] $Before = {$false},
# The input value to test.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)] $InputObject,
# Passes through the input values that match the range rather than returning true or false.
[switch] $Filter
)
Begin {$inRange = $false}
Process
{
	if(!$inRange) {$inRange = $After.InvokeReturnAsIs($InputObject)}
	elseif($inRange) {$inRange = !$Before.InvokeReturnAsIs($InputObject)}
	if(!$Filter) {return $inRange}
	elseif($inRange) {return $InputObject}
}
