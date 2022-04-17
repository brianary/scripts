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
Get-Process |% Handles |Measure-StandardDeviation.ps1

1206.54722086141
#>

#Requires -Version 3
[CmdletBinding()][OutputType([double])] Param(
[Parameter(Position=0,ValueFromRemainingArguments=$true,ValueFromPipeline=$true)]
[double[]] $Values
)
End
{
	[double[]] $data = $input.Foreach({$_}) # flatten nested arrays
	[double] $average = $data |measure -Average |% Average
	Write-Verbose "Average = $average"
	[double[]] $deviations = $data |% {[math]::Pow(($_-$average),2)}
	Write-Verbose "Deviations = { $deviations }"
	[double] $variance = ($deviations |measure -Sum).Sum/$data.Count
	Write-Verbose "Variance = $variance"
	[double] $stddev = [math]::Sqrt($variance)
	Write-Verbose "Standard deviation = $stddev"
	$stddev
}
