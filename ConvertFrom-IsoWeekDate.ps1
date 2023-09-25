<#
.SYNOPSIS
Returns a DateTime object from an ISO week date string.

.INPUTS
System.String containing an ISO week date.

.OUTPUTS
System.DateTime corresponding to the ISO week date.

.FUNCTIONALITY
Date and time

.LINK
https://en.wikipedia.org/wiki/ISO_week_date

.EXAMPLE
ConvertFrom-IsoWeekDate.ps1 2000-W01-1

Monday, January 3, 2000 00:00:00

.EXAMPLE
ConvertFrom-IsoWeekDate.ps1 2022-W08-2

Tuesday, February 22, 2022 00:00:00
#>

#Requires -Version 3
[CmdletBinding()][OutputType([datetime])] Param(
# An ISO week date of the formatt ####-W##-#.
[Parameter(Position=0,ValueFromPipeline=$true)][ValidatePattern('\A\d+-W\d\d-\d\z')][string] $InputObject
)
Process
{
	if($InputObject -notmatch '\A(?<Year>\d+)-W(?<Week>\d\d)-(?<DayOfWeek>\d)\z')
	{
		Stop-ThrowError.ps1 "Unable to parse '$InputObject' as an ISO week date." -Argument InputObject
	}
	$year,$week,$dow = [int]$Matches.Year,([int]($Matches.Week)-1),[int]$Matches.DayOfWeek
	$yearstart = New-Object DateTime $year,1,1
	$startdow = [int]$yearstart.DayOfWeek
	if($startdow -gt 4) {return $yearstart.AddDays(7*$week+$dow+(7-$startdow))}
	else {return $yearstart.AddDays(7*$week+$dow-$startdow)}
}
