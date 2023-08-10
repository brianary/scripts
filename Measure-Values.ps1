<#
.SYNOPSIS
Provides analysis of supplied values.
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The values to analyze.
[Parameter(ValueFromPipeline)] $InputObject
)
Begin
{
	function Measure-Stats([Collections.ArrayList] $numbers)
	{
		$stats = $numbers |Measure-Object -AllStats
		$sorted = $numbers |Sort-Object
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
			MedianAverage     = $sorted.Length -band 1 ? ($sorted[[math]::Floor($middle)]+$sorted[[math]::Ceiling($middle)])/2 : $sorted[$middle]
			ModeAverage       = $mode.Average
			Variance          = [math]::Pow($stats.StandardDeviation,2)
			StandardDeviation = $stats.StandardDeviation
		}
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
			$stats = Measure-Stats $values[$type]
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
			$lenstats = Measure-Stats ($values[$type] |Select-Object -ExpandProperty Length)
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
			$stats = $values[$type] |Measure-Object -Minimum -Maximum
			$unique = @($values[$type] |Select-Object -Unique).Count
			$dateonly,$datetime = $type -eq [dateonly] ? @($values[$type],0) :
				@($values[$type] |Group-Object {$_ -ne $_.Date} |Sort-Object {$_.Values[0]} |Select-Object -ExpandProperty Count)
			return [pscustomobject]@{
				Type                = $type
				Values              = $values[$type].Count
				NullValues          = $nulls
				IsUnique            = $unique -lt $values[$type].Count ? $false : $true
				UniqueValues        = $unique
				IsDateOnly          = !$datetime
				DateOnlyValues      = $dateonly
				DateTimeValues      = $datetime
				Minimum             = $stats.Minimum
				Maximum             = $stats.Maximum
				MostCommonValue     = $values[$type] |Group-Object -NoElement |Sort-Object Count -Descending |Select-Object -First 1 -ExpandProperty Values
				Sunday              = @($values[$type] |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Sunday}).Count
				Monday              = @($values[$type] |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Monday}).Count
				Tuesday             = @($values[$type] |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Tuesday}).Count
				Wednesday           = @($values[$type] |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Wednesday}).Count
				Thursday            = @($values[$type] |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Thursday}).Count
				Friday              = @($values[$type] |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Friday}).Count
				Saturday            = @($values[$type] |Where-Object {$_.DayOfWeek -eq [DayOfWeek]::Saturday}).Count
				January             = @($values[$type] |Where-Object {$_.Month -eq 1}).Count
				Febuary             = @($values[$type] |Where-Object {$_.Month -eq 2}).Count
				March               = @($values[$type] |Where-Object {$_.Month -eq 3}).Count
				April               = @($values[$type] |Where-Object {$_.Month -eq 4}).Count
				May                 = @($values[$type] |Where-Object {$_.Month -eq 5}).Count
				June                = @($values[$type] |Where-Object {$_.Month -eq 6}).Count
				July                = @($values[$type] |Where-Object {$_.Month -eq 7}).Count
				August              = @($values[$type] |Where-Object {$_.Month -eq 8}).Count
				September           = @($values[$type] |Where-Object {$_.Month -eq 9}).Count
				October             = @($values[$type] |Where-Object {$_.Month -eq 10}).Count
				November            = @($values[$type] |Where-Object {$_.Month -eq 11}).Count
				December            = @($values[$type] |Where-Object {$_.Month -eq 12}).Count
			}
			#TODO
			<#
			ModeAverage     : 03/31/2014 00:00:00
			MeanYear        : 2013
			ModeYear        : 2013
			MeanMonth       : January
			ModeMonth       : May
			MeanDayOfWeek   : Thursday
			ModeDayOfWeek   : Monday
			MeanDayOfMonth  : 16
			#>
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
