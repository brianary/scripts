<#
.Synopsis
    Parses a Timespan from a ISO8601 duration string.

.Parameter InputObject
    An ISO8601 duration string in one of four formats:

        * PnYnMnDTnHnMnS
        * PnW
        * Pyyyy-MM-ddTHH:mm:ss
        * PyyyyMMddTHHmmss

.Parameter NoWarnings
    Supresses warnings about approximate conversions.

.Inputs
    System.String containing an ISO8601 duration.

.Outputs
    System.Timespan containing the duration, as parsed and converted to a Timespan.

.Link
    https://en.wikipedia.org/wiki/ISO_8601#Durations

.Example
    "$(ConvertFrom-Duration.ps1 P1D)"

    1.00:00:00

.Example
    "$(ConvertFrom-Duration.ps1 P3Y6M4DT12H30M5S)"

    WARNING: Adding year(s) as a mean number of days (365.2425).
    WARNING: Adding month(s) as a mean number of days (30.436875).
    1283.12:30:05
#>

#Requires -Version 3
[CmdletBinding()][OutputType([timespan])] Param(
[Parameter(Position=0,ValueFromPipeline=$true,ValueFromRemainingArguments)]
[ValidatePattern('\AP\d(?:\w+|\d\d\d(?:-\d\d){2}T\d\d(?::\d\d){2})\z')]
[string[]] $InputObject,
[Alias('Quiet')][switch]$NoWarnings
)
Begin
{
    $MeanMonth,$MeanYear = 30.436875,365.2425
    [regex[]]$formats = '\AP(?<Weeks>\d+)W\z',
        '\AP(?:(?<Years>\d+)Y)?(?:(?<Months>\d+)M)?(?:(?<Days>\d+)D)?(?:T(?:(?<Hours>\d+)H)?(?:(?<Minutes>\d+)M)?(?:(?<Seconds>\d+)S)?)?\z',
        '\AP(?<Years>\d{4})-(?<Months>\d{2})-(?<Days>\d{2})T(?<Hours>\d{2}):(?<Minutes>\d{2}):(?<Seconds>\d{2})\z',
        '\AP(?<Years>\d{4})(?<Months>\d{2})(?<Days>\d{2})T(?<Hours>\d{2})(?<Minutes>\d{2})(?<Seconds>\d{2})\z'
}
Process
{
    foreach($o in $InputObject)
    {
        [bool]$matched = $false
        foreach($f in $formats)
        {
            if($o -match $f) {$matched = $true; break}
        }
        if(!$matched)
        {
            Stop-ThrowError.ps1 "Could not parse '$o' as an ISO8601 duration." -Argument InputObject
        }
        Import-Variables.ps1 $Matches
        [timespan]$value = 0
        if(Test-Variable.ps1 Years)
        {
            if(!$NoWarnings) {Write-Warning "Adding year(s) as a mean number of days ($MeanYear)."}
            $value += New-Object Timespan ($MeanYear*[int]$Years),0,0,0
        }
        if(Test-Variable.ps1 Months)
        {
            if(!$NoWarnings) {Write-Warning "Adding month(s) as a mean number of days ($MeanMonth)."}
            $value += New-Object Timespan ($MeanMonth*[int]$Months),0,0,0
        }
        if(Test-Variable.ps1 Weeks) {$value += New-Object Timespan (7*[int]$Weeks),0,0,0}
        if(Test-Variable.ps1 Days) {$value += New-Object Timespan ([int]$Days),0,0,0}
        if(Test-Variable.ps1 Hours) {$value += New-Object Timespan ([int]$Hours),0,0}
        if(Test-Variable.ps1 Minutes) {$value += New-Object Timespan 0,([int]$Minutes),0}
        if(Test-Variable.ps1 Seconds) {$value += New-Object Timespan 0,0,([int]$Seconds)}
        $value
    }
}
