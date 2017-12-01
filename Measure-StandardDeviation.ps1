<#
.Synopsis
    Calculate the standard deviation of numeric values.

.Inputs
    A collection of System.Double values

.Outputs
    System.Double

.Link
    Measure-Object

.Example
    Get-Process |% Handles |Measure-StandardDeviation.ps1

    1206.54722086141
#>

#Requires -Version 3
[CmdletBinding()][OutputType([double])] Param(
[Parameter(Position=0,ValueFromRemainingArguments=$true,ValueFromPipeline=$true)]
[double[]]$Values
)
Begin {[Collections.Generic.List[double]]$Script:Data = @() }
Process {$Script:Data.AddRange($Values)}
End
{
    [double]$average = $Script:Data |measure -Average |% Average
    Write-Verbose "Average = $average"
    [double[]]$deviations = $Script:Data |% {[math]::Pow(($_-$average),2)}
    Write-Verbose "Deviations = { $deviations }"
    [double]$variance = ($deviations |measure -Sum).Sum/$Script:Data.Count
    Write-Verbose "Variance = $variance"
    [double]$stddev = [math]::Sqrt($variance)
    Write-Verbose "Standard deviation = $stddev"
    $stddev
}
