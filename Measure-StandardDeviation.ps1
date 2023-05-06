<#
.SYNOPSIS
Calculate the standard deviation of numeric values.

.INPUTS
A collection of System.Double values

.OUTPUTS
System.Double

.LINK
Measure-Object

.EXAMPLE
Get-Item *.ps1 |% Length |Measure-StandardDeviation.ps1

3870.16158336182

.EXAMPLE
Measure-StandardDeviation.ps1 (1..20)

5.7662812973354
#>

#Requires -Version 3
[CmdletBinding()][OutputType([double])] Param(
# The numeric values to analyze.
[Parameter(Position=0,ValueFromRemainingArguments=$true,ValueFromPipeline=$true)]
[double[]] $InputObject
)
End
{
	[double[]] $values = if($input) {$input} else {$InputObject}
	[double] $average = $values |Measure-Object -Average |Select-Object -ExpandProperty Average
	Write-Verbose "Average = $average"
	[double[]] $deviations = $values |ForEach-Object {[math]::Pow(($_-$average),2)}
	Write-Verbose "Deviations = { $deviations }"
	[double] $variance = ($deviations |Measure-Object -Sum).Sum/$values.Count
	Write-Verbose "Variance = $variance"
	[double] $stddev = [math]::Sqrt($variance)
	Write-Verbose "Standard deviation = $stddev"
	return $stddev
}
