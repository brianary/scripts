<#
.Synopsis
    Returns true if the given date is a U.S. federal holiday.

.Description
    The following holidays are checked:

        * New Year's Day, January 1 (± 1 day, if observed)
        * Birthday of Martin Luther King, Jr., Third Monday in January
        * Washington's Birthday, Third Monday in February
        * Memorial Day, Last Monday in May
        * Independence Day, July 4 (± 1 day, if observed)
        * Labor Day, First Monday in September
        * Columbus Day, Second Monday in October
        * Veterans Day, November 11 (±1 day, if observed)
        * Thanksgiving Day, Fourth Thursday in November
        * Christmas Day, December 25 (±1 day, if observed)

.Parameter Date
    The date to check.

.Parameter SatToFri
    Indicates Saturday holidays are observed on Fridays.

.Parameter SunToMon
    Indicates Sunday holidays are observed on Mondays.

.Notes
    Thanks to the Uniform Monday Holiday Act, Washington's "Birthday" always falls
    *between* Washington's birthdays. He had two, and we still decided to celebrate
    a third day.

    https://en.wikipedia.org/wiki/Uniform_Monday_Holiday_Act

    https://en.wikipedia.org/wiki/Washington%27s_Birthday#History

.Inputs
    System.DateTime values to check.

.Outputs
    System.Boolean indicating whether the date is a holiday.

.Link
    http://www.federalreserve.gov/aboutthefed/k8.htm

.Example
    Test-USFederalHoliday.ps1 2016-11-11

    Veterans Day

.Example
    Test-USFederalHoliday.ps1 2017-02-20

    Washington's Birthday

.Example
    if(Test-USFederalHoliday.ps1 (Get-Date)) { return }

    Returns from a function or script if today is a holiday.
#>

[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][datetime]$Date,
[Parameter(HelpMessage='Are Saturday holidays observed on Friday?')][switch]$SatToFri,
[Parameter(HelpMessage='Are Sunday holidays observed on Monday?')][switch]$SunToMon
)
Process
{
    $showdate = Get-Date $Date -f D
    $MMdd= '{0:MMdd}' -f $Date
    switch($Date.DayOfWeek)
    {
        Monday
        {
            switch -regex ($MMdd)
            {
                '^01(?:1[5-9]|2[01])$' {Write-Verbose "$showdate is Birthday of Martin Luther King, Jr."; return $true}
                '^02(?:1[5-9]|2[01])$' {Write-Verbose "$showdate is Washington's Birthday"; return $true}
                '^05(?:2[5-9]|3[01])$' {Write-Verbose "$showdate is Memorial Day"; return $true}
                '^090[1-7]$' {Write-Verbose "$showdate is Labor Day"; return $true}
                '^10(?:0[89]|1[01-4])$' {Write-Verbose "$showdate is Columbus Day"; return $true}
            }
            if($SunToMon)
            {
                switch($MMdd)
                {
                    '0102' {Write-Verbose "$showdate is New Year's Day (Observed)"; return $true}
                    '0705' {Write-Verbose "$showdate is Independence Day (Observed)"; return $true}
                    '1112' {Write-Verbose "$showdate is Veterans Day (Observed)"; return $true}
                    '1226' {Write-Verbose "$showdate is Christmas Day (Observed)"; return $true}
                }
            }
        }
        Thursday
        {
            if($MMdd -match '^112[2-8]$') {Write-Verbose "$showdate is Thanksgiving Day"; return $true}
        }
        Friday
        {
            if($SatToFri)
            {
                switch($MMdd)
                {
                    '1231' {Write-Verbose "$showdate is New Year's Day (Observed)"; return $true}
                    '0703' {Write-Verbose "$showdate is Independence Day (Observed)"; return $true}
                    '1110' {Write-Verbose "$showdate is Veteran's Day (Observed)"; return $true}
                    '1224' {Write-Verbose "$showdate is Christmas Day (Observed)"; return $true}
                }
            }
        }
    }
    switch($MMdd)
    {
        '0101' {Write-Verbose "$showdate is New Year's Day"; return $true}
        '0704' {Write-Verbose "$showdate is Independence Day"; return $true}
        '1111' {Write-Verbose "$showdate is Veteran's Day"; return $true}
        '1225' {Write-Verbose "$showdate is Christmas Day"; return $true}
    }
    Write-Verbose "$showdate is not a US federal holiday"
    return $false
}
