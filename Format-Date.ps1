<#
.SYNOPSIS
Returns a date/time as a named format.

.FUNCTIONALITY
Date and time

.LINK
Get-Date

.EXAMPLE
Format-Date Iso8601WeekDate 2021-01-20

2021-W03-3

.EXAMPLE
'Feb 2, 2020 8:20 PM +00:00' |Format-Date Iso8601Z

2020-02-02T20:20:00Z
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# The format to serialize the date as.
[Parameter(Position=0,Mandatory=$true)]
[ValidateSet('FrenchRepublicanDateTime','Iso8601','Iso8601Date','Iso8601OrdinalDate',
'Iso8601Week','Iso8601WeekDate','Iso8601Z','LocalLongDate','LocalLongDateTime','Rfc1123','Rfc1123Gmt')]
[string] $Format,
# The date/time value to format.
[Parameter(Position=1,ValueFromPipeline=$true)][datetime] $Date = (Get-Date)
)
Process
{
	switch($Format)
	{
		FrenchRepublicanDateTime {"$(Get-FrenchRepublicanDate.ps1 $Date)"}
		Iso8601 {Get-Date $Date -f "yyyy'-'MM'-'dd'T'HH':'mm':'sszzzz"}
		Iso8601Date {Get-Date $Date -uf %Y-%m-%d} # PS5 doesn't support %F
		Iso8601OrdinalDate {Get-Date $Date -uf "%Y-$('{0:000}' -f $Date.DayOfYear)"}
		Iso8601Week
		{
			$V = '{0:00}' -f [int](Get-Date $Date -uf %V) # PS5 doesn't zero-pad %V
			if(53 -eq (Get-Date $Date -uf %V) -and $Date.Month -eq 1) {"$($Date.Year-1)-W$V"}
			else {Get-Date $Date -uf %Y-W$V}
		}
		Iso8601WeekDate
		{
			$w = [int]$Date.DayOfWeek; if($w -eq 0) {$w = 7} # PS5-7.1 formats Sundays as zero
			$V = '{0:00}' -f [int](Get-Date $Date -uf %V)
			if(53 -eq (Get-Date $Date -uf %V) -and $Date.Month -eq 1) {"$($Date.Year-1)-W$V-$w"}
			else {Get-Date $Date -uf %Y-W$V-$w}
		}
		Iso8601Z {"$(Get-Date $Date.ToUniversalTime() -f s)Z"}
		LocalLongDate {Get-Date $Date -f D}
		LocalLongDateTime {Get-Date $Date -f F}
		Rfc1123 {Get-Date $Date -uf '%a, %e %b %Y %T %Z'} # CLR R format zero-pads date instead of space-padding like %e
		Rfc1123Gmt {Get-Date $Date.ToUniversalTime() -uf '%a, %e %b %Y %T GMT'}
	}
}
