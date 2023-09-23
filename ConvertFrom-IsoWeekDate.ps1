<#
.SYNOPSIS
Returns a DateTime object from an ISO week date string.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,ValueFromPipeline=$true)][ValidatePattern('\A\d+-W\d\d-\d\z')][string] $InputObject
)
Process
{
	if($InputObject -notmatch '\A(?<Year>\d+)-W(?<Week>\d\d)-(?<DayOfWeek>\d)\z')
	{
		Stop-ThrowError.ps1 "Unable to parse '$InputObject' as an ISO week date." -Argument InputObject
	}
	$year,$week,$dow = [int]$Matches.Year,[int]$Matches.Week,[int]$Matches.DayOfWeek
	$value = New-Object DateTime $year,1,1
	$startdow = [int]$value.DayOfWeek
	if($startdow -gt 4) {return $value.AddDays(7*$week+$dow+(7-$startdow))}
	else {return $value.AddDays(7*$week+$dow-$startdow)}
}
