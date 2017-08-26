<#
.Synopsis
    Returns the name of the holiday of a date, if it is a U.S. federal holiday.

.Description
    The following holidays are checked:
        * New Year's Day, January 1 (± 1 day, if observed)
        * Martin Luther King, Jr. Day, Third Monday in January
        * President's Day, Third Monday in February
        * Memorial Day, Last Monday in May
        * Independence Day, July 4 (± 1 day, if observed)
        * Labor Day, First Monday in September
        * Columbus Day, Second Monday in October
        * Veteran's Day, November 11 (±1 day, if observed)
        * Thanksgiving Day, Fourth Thursday in November
        * Christmas Day, December 25 (±1 day, if observed)

.Parameter Date
    The date to check.

.Parameter SatToFri
    Indicates Saturday holidays are observed on Fridays.

.Parameter SunToMon
    Indicates Sunday holidays are observed on Mondays.

.Inputs
    System.DateTime values to check.

.Outputs
    System.String containing the holiday name when the date is a holiday.

.Link
    http://www.federalreserve.gov/aboutthefed/k8.htm

.Example
    Test-USFederalHoliday.ps1 2016-11-11


    Veterans Day

.Example
    Test-USFederalHoliday.ps1 2017-02-20


    Washington's Birthday

.Example
    if(!(Test-USFederalHoliday.ps1 ([datetime]::Today))) { Invoke-SomeBusinessDayTask }


    Runs Invoke-SomeBusinessDayTask only if today is not a holiday.
#>

[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][datetime]$Date,
[Parameter(HelpMessage='Are Saturday holidays observed on Friday?')][switch]$SatToFri,
[Parameter(HelpMessage='Are Sunday holidays observed on Monday?')][switch]$SunToMon
)
Process
{
    $MMdd= '{0:MMdd}' -f $Date
    switch($Date.DayOfWeek)
    {
        Monday
        {
            switch -regex ($MMdd)
            {
                '^01(?:1[5-9]|2[01])$' {return 'Birthday of Martin Luther King, Jr.'}
                '^02(?:1[5-9]|2[01])$' {return 'Washington''s Birthday'}
                '^05(?:2[5-9]|3[01])$' {return 'Memorial Day'}
                '^090[1-7]$' {return 'Labor Day'}
                '^10(?:0[89]|1[01-4])$' {return 'Columbus Day'}
            }
            if($SunToMon)
            {
                switch($MMdd)
                {
                    '0102' {return 'New Year''s Day (Observed)'}
                    '0705' {return 'Independence Day (Observed)'}
                    '1112' {return 'Veterans Day (Observed)'}
                    '1226' {return 'Christmas Day (Observed)'}
                }
            }
        }
        Thursday
        {
            if($MMdd -match '^112[2-8]$') {return 'Thanksgiving Day'}
        }
        Friday
        {
            if($SatToFri)
            {
                switch($MMdd)
                {
                    '1231' {return 'New Year''s Day (Observed)'}
                    '0703' {return 'Independence Day (Observed)'}
                    '1110' {return 'Veteran''s Day (Observed)'}
                    '1224' {return 'Christmas Day (Observed)'}
                }
            }
        }
    }
    switch($MMdd)
    {
        '0101' {return 'New Year''s Day'}
        '0704' {return 'Independence Day'}
        '1111' {return 'Veteran''s Day'}
        '1225' {return 'Christmas Day'}
    }
}
