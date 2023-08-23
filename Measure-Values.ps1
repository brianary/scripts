<#
.SYNOPSIS
Provides analysis of supplied values.

.INPUTS
System.Object values to be analyzed in aggregate.

.OUTPUTS
System.Management.Automation.PSCustomObject that describes the values with properties like
MeanAverage and StandardDeviation.

.FUNCTIONALITY
Data

.EXAMPLE
1..54 |ForEach-Object {Get-Random} |Measure-Values.ps1

Type              : System.Int32
Values            : 54
NullValues        : 0
IsUnique          : True
UniqueValues      : 54
Minimum           : 94194382
Maximum           : 2128816298
MeanAverage       : 1088097395.2963
MedianAverage     : 1223934436
ModeAverage       : 1088097395.2963
Variance          : 3.74619103093056E+17
StandardDeviation : 612061355.660571

.EXAMPLE
1..127 |ForEach-Object {Get-Date -UnixTimeSeconds (Get-Random)} |Measure-Values.ps1

Type                     : System.DateTime
Values                   : 127
NullValues               : 0
IsUnique                 : True
UniqueValues             : 127
IsDateOnly               : False
DateOnlyValues           : 0
DateTimeValues           : 127
Minimum                  : 1970-12-23 12:18:33
Maximum                  : 2037-10-28 21:09:37
MostCommonValue          : 1970-12-23 12:18:33
MeanAverage              : 2002-09-23 09:03:30
MedianAverage            : 2002-07-23 06:51:20
ModeAverage              : 2002-09-23 09:03:30
UniqueYears              : 59
MeanAverageYear          : 2002
MedianAverageYear        : 2002
ModeAverageYear          : 1979
StandardDeviationYear    : 20.9125879067699
UniqueMonths             : 12
MinimumMonth             : January
MaximumMonth             : December
MeanAverageMonth         : July
MedianAverageMonth       : June
ModeAverageMonth         : May
StandardDeviationMonth   : 3.45228333389263
January                  : 10
Febuary                  : 6
March                    : 16
April                    : 7
May                      : 19
June                     : 11
July                     : 6
August                   : 7
September                : 14
October                  : 10
November                 : 7
December                 : 14
UniqueDays               : 29
MinimumDay               : 1
MaximumDay               : 30
MeanAverageDay           : 15.4645669291339
MedianAverageDay         : 15
ModeAverageDay           : 7
StandardDeviationDay     : 8.53172908617298
UniqueWeekdays           : 7
MinimumWeekday           : Sunday
MaximumWeekday           : Saturday
MeanAverageWeekday       : Wednesday
MedianAverageWeekday     : Wednesday
ModeAverageWeekday       : Wednesday
StandardDeviationWeekday : 1.92091482392633
Sunday                   : 13
Monday                   : 20
Tuesday                  : 21
Wednesday                : 23
Thursday                 : 16
Friday                   : 15
Saturday                 : 19
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The values to analyze.
[Parameter(ValueFromPipeline)] $InputObject
)
Begin
{
	function Measure-Stats([Parameter(ValueFromPipeline=$true)][double] $NumericValues)
	{End{
		$numbers = $input
		$stats = $numbers |Measure-Object -AllStats
		$sorted = @($numbers |Sort-Object)
		$middle = $sorted.Length/2
		$frequency = $numbers |Group-Object -NoElement |Sort-Object Count -Descending
		$mode = $frequency |Where-Object Count -eq $frequency[0].Count |
			Select-Object -ExpandProperty Values |Measure-Object -Average
		return [pscustomobject]@{
			UniqueValues      = @($numbers |Select-Object -Unique).Count
			Sum               = $stats.Sum
			Minimum           = $stats.Minimum
			Maximum           = $stats.Maximum
			MeanAverage       = $stats.Average
			MedianAverage     = switch($sorted.Length)
			{
				1 {$sorted[0]}
				{$_ -gt 1 -and $_ -band 1} {($sorted[[math]::Floor($middle)]+$sorted[[math]::Ceiling($middle)])/2}
				default {$sorted[$middle]}
			}
			ModeAverage       = $mode.Average
			Variance          = [math]::Pow($stats.StandardDeviation,2)
			StandardDeviation = $stats.StandardDeviation
		}
	}}
	function Get-MonthName([int] $Month)
	{
		return (Get-Culture).DateTimeFormat.GetMonthName($Month)
	}
	$nulls = 0
	[Collections.Generic.Dictionary[[type],[Collections.ArrayList]]] $values = @{}
}
Process
{
	if($null -eq $InputObject) {$nulls++}
	elseif($InputObject -is [DBNull]) {$nulls++}
	else
	{
		$type = $InputObject.GetType()
		if($values.ContainsKey($type)) {$values[$type] += $InputObject}
		else {$values.Add($type,@($InputObject))}
	}
}
End
{
	foreach($type in $values.Keys)
	{
		if($type -in [int],[long],[byte],[decimal],[double],[float],[short],[sbyte],[uint16],[uint32],[uint64],[bigint],[char])
		{
			$stats = $values[$type] |Measure-Stats
			return [pscustomobject]@{
				Type              = $type
				Values            = $values[$type].Count
				NullValues        = $nulls
				IsUnique          = $stats.UniqueValues -lt $values[$type].Count ? $false : $true
				UniqueValues      = $stats.UniqueValues
				Minimum           = $stats.Minimum
				Maximum           = $stats.Maximum
				MeanAverage       = $stats.MeanAverage
				MedianAverage     = $stats.MedianAverage
				ModeAverage       = $stats.ModeAverage
				Variance          = $stats.Variance
				StandardDeviation = $stats.StandardDeviation
			}
		}
		elseif($type -eq [string])
		{
			$stats = $values[$type] |Measure-Object -Minimum -Maximum
			$lenstats = $values[$type] |Select-Object -ExpandProperty Length |Measure-Stats
			$unique = @($values[$type] |Select-Object -Unique).Count
			return [pscustomobject]@{
				Type                = $type
				Values              = $values[$type].Count
				NullValues          = $nulls
				IsUnique            = $unique -lt $values[$type].Count ? $false : $true
				UniqueValues        = $unique
				Minimum             = $stats.Minimum
				Maximum             = $stats.Maximum
				MinimumLength       = $lenstats.Minimum
				MaximumLength       = $lenstats.Maximum
				MeanAverageLength   = $lenstats.MeanAverage
				MedianAverageLength = $lenstats.MedianAverage
				ModeAverageLength   = $lenstats.ModeAverage
				VarianceLength      = $lenstats.Variance
				StandardDeviation   = $lenstats.StandardDeviation
			}
		}
		elseif($type -in [datetime],[dateonly],[timeonly],[datetimeoffset])
		{
			[Collections.ArrayList] $v = $values[$type]
			[Collections.ArrayList] $e = $v |ConvertTo-EpochTime.ps1
			$stats = $v |Measure-Object -Minimum -Maximum
			$estats = $e |Measure-Stats
			$ystats = $v |Select-Object -ExpandProperty Year |Measure-Stats
			$mstats = $v |Select-Object -ExpandProperty Month |Measure-Stats
			$dstats = $v |Select-Object -ExpandProperty Day |Measure-Stats
			$wstats = $v |ForEach-Object {[int]$_.DayOfWeek} |Measure-Stats
			$unique = @($v |Select-Object -Unique).Count
			$dateonly = $type -eq [dateonly] ? $v : @($v |Where-Object {$_ -eq $_.Date}).Count
			$datetime = $v.Count - $dateonly
			return [pscustomobject]@{
				Type                     = $type
				Values                   = $v.Count
				NullValues               = $nulls
				IsUnique                 = $unique -lt $v.Count ? $false : $true
				UniqueValues             = $unique
				IsDateOnly               = !$datetime
				DateOnlyValues           = $dateonly
				DateTimeValues           = $datetime
				Minimum                  = $stats.Minimum
				Maximum                  = $stats.Maximum
				MostCommonValue          = $v |Group-Object -NoElement |Sort-Object Count -Descending |Select-Object -First 1 -ExpandProperty Values
				MeanAverage              = Get-Date -UnixTimeSeconds ([int]$estats.MeanAverage)
				MedianAverage            = Get-Date -UnixTimeSeconds ([int]$estats.MedianAverage)
				ModeAverage              = Get-Date -UnixTimeSeconds ([int]$estats.ModeAverage)
				UniqueYears              = $ystats.UniqueValues
				MeanAverageYear          = [int]($ystats.MeanAverage)
				MedianAverageYear        = [int]($ystats.MedianAverage)
				ModeAverageYear          = [int]($ystats.ModeAverage)
				StandardDeviationYear    = $ystats.StandardDeviation
				UniqueMonths             = $mstats.UniqueValues
				MinimumMonth             = Get-MonthName $mstats.Minimum
				MaximumMonth             = Get-MonthName $mstats.Maximum
				MeanAverageMonth         = Get-MonthName $mstats.MeanAverage
				MedianAverageMonth       = Get-MonthName $mstats.MedianAverage
				ModeAverageMonth         = Get-MonthName $mstats.ModeAverage
				StandardDeviationMonth   = $mstats.StandardDeviation
				January                  = @($v |Where-Object {$_.Month -eq 1}).Count
				Febuary                  = @($v |Where-Object {$_.Month -eq 2}).Count
				March                    = @($v |Where-Object {$_.Month -eq 3}).Count
				April                    = @($v |Where-Object {$_.Month -eq 4}).Count
				May                      = @($v |Where-Object {$_.Month -eq 5}).Count
				June                     = @($v |Where-Object {$_.Month -eq 6}).Count
				July                     = @($v |Where-Object {$_.Month -eq 7}).Count
				August                   = @($v |Where-Object {$_.Month -eq 8}).Count
				September                = @($v |Where-Object {$_.Month -eq 9}).Count
				October                  = @($v |Where-Object {$_.Month -eq 10}).Count
				November                 = @($v |Where-Object {$_.Month -eq 11}).Count
				December                 = @($v |Where-Object {$_.Month -eq 12}).Count
				UniqueDays               = $dstats.UniqueValues
				MinimumDay               = $dstats.Minimum
				MaximumDay               = $dstats.Maximum
				MeanAverageDay           = $dstats.MeanAverage
				MedianAverageDay         = $dstats.MedianAverage
				ModeAverageDay           = $dstats.ModeAverage
				StandardDeviationDay     = $dstats.StandardDeviation
				UniqueWeekdays           = $wstats.UniqueValues
				MinimumWeekday           = [DayOfWeek] $wstats.Minimum
				MaximumWeekday           = [DayOfWeek] $wstats.Maximum
				MeanAverageWeekday       = [DayOfWeek][int] $wstats.MeanAverage
				MedianAverageWeekday     = [DayOfWeek][int] $wstats.MedianAverage
				ModeAverageWeekday       = [DayOfWeek][int] $wstats.ModeAverage
				StandardDeviationWeekday = $wstats.StandardDeviation
				Sunday                   = @($v |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Sunday}).Count
				Monday                   = @($v |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Monday}).Count
				Tuesday                  = @($v |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Tuesday}).Count
				Wednesday                = @($v |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Wednesday}).Count
				Thursday                 = @($v |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Thursday}).Count
				Friday                   = @($v |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Friday}).Count
				Saturday                 = @($v |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Saturday}).Count
			}
		}
		elseif($type -eq [bool])
		{
			return [pscustomobject]@{
				Type        = $type
				Values            = $values[$type].Count
				NullValues  = $nulls
				FalseValues = @($values[$type] |Where-Object {!$_}).Count
				TrueValues  = @($values[$type] |Where-Object {$_}).Count
			}
		}
		else
		{
			return [pscustomobject]@{
				Type       = $type
				Values     = $values[$type].Count
				NullValues = $nulls
			}
		}
	}
}
