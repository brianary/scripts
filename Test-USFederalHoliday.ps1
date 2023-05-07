<#
.SYNOPSIS
Returns true if the given date is a U.S. federal holiday.

.DESCRIPTION
The following holidays are checked:

* New Year's Day, January 1 (± 1 day, if observed)
* Birthday of Martin Luther King, Jr., Third Monday in January
* Washington's Birthday, Third Monday in February
* Memorial Day, Last Monday in May
* Juneteenth, June 19 (± 1 day, if observed)
* Independence Day, July 4 (± 1 day, if observed)
* Labor Day, First Monday in September
* Columbus Day, Second Monday in October
* Veterans Day, November 11 (±1 day, if observed)
* Thanksgiving Day, Fourth Thursday in November
* Christmas Day, December 25 (±1 day, if observed)

.NOTES
Thanks to the Uniform Monday Holiday Act, Washington's "Birthday" always falls
*between* Washington's birthdays. He had two, and we still decided to celebrate
a third day.

https://en.wikipedia.org/wiki/Uniform_Monday_Holiday_Act

https://en.wikipedia.org/wiki/Washington%27s_Birthday#History

.INPUTS
System.DateTime values to check.

.OUTPUTS
System.Boolean indicating whether the date is a holiday.

.FUNCTIONALITY
Date and time

.LINK
http://www.federalreserve.gov/aboutthefed/k8.htm

.EXAMPLE
Test-USFederalHoliday.ps1 2016-11-11

Veterans Day

.EXAMPLE
Test-USFederalHoliday.ps1 2017-02-20

Washington's Birthday

.EXAMPLE
if(Test-USFederalHoliday.ps1 (Get-Date)) { return }

Returns from a function or script if today is a holiday.
#>

[CmdletBinding()][OutputType([bool])] Param(
# The date to check.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][datetime] $Date,
# Return the holiday name as a truthy value, rather than true.
[Parameter(HelpMessage='Return the holiday name?')][Alias('ReturnName','ReturnHolidayName')][switch] $AsHolidayName,
# Indicates Saturday holidays are observed on Fridays.
[Parameter(HelpMessage='Are Saturday holidays observed on Friday?')][switch] $SatToFri,
# Indicates Sunday holidays are observed on Mondays.
[Parameter(HelpMessage='Are Sunday holidays observed on Monday?')][switch] $SunToMon
)
Process
{
	$showdate = Get-Date $Date -f D
	$MMdd= '{0:MMdd}' -f $Date
	$holiday =
	switch($MMdd)
	{
		'0101' {"New Year's Day"}
		'0619' {"Juneteenth"}
		'0704' {"Independence Day"}
		'1111' {"Veteran's Day"}
		'1225' {"Christmas Day"}
		default
		{
			switch($Date.DayOfWeek)
			{
				Monday
				{
					switch -regex ($MMdd)
					{
						'^01(?:1[5-9]|2[01])$' {"Birthday of Martin Luther King, Jr."}
						'^02(?:1[5-9]|2[01])$' {"Washington's Birthday"}
						'^05(?:2[5-9]|3[01])$' {"Memorial Day"}
						'^090[1-7]$' {"Labor Day"}
						'^10(?:0[89]|1[01-4])$' {"Columbus Day"}
					}
					if($SunToMon)
					{
						switch($MMdd)
						{
							'0102' {"New Year's Day (Observed)"}
							'0620' {"Juneteenth (Observed)"}
							'0705' {"Independence Day (Observed)"}
							'1112' {"Veterans Day (Observed)"}
							'1226' {"Christmas Day (Observed)"}
						}
					}
				}
				Thursday
				{
					if($MMdd -match '^112[2-8]$') {"Thanksgiving Day"}
				}
				Friday
				{
					if($SatToFri)
					{
						switch($MMdd)
						{
							'1231' {"New Year's Day (Observed)"}
							'0618' {"Juneteenth (Observed)"}
							'0703' {"Independence Day (Observed)"}
							'1110' {"Veteran's Day (Observed)"}
							'1224' {"Christmas Day (Observed)"}
						}
					}
				}
			}
		}
	}
	if($holiday)
	{
		if($ReturnName) {return $holiday}
		else
		{
			Write-Verbose "$showdate is $holiday"
			return $true
		}
	}
	else
	{
		Write-Verbose "$showdate is not a US federal holiday"
		return $false
	}
}
