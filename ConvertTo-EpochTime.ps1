<#
.SYNOPSIS
Converts a DateTime value into an integer Unix (POSIX) time, seconds since Jan 1, 1970.

.INPUTS
System.DateTime value to convert to integer.

.OUTPUTS
System.Int32 value converted from date and time value.

.FUNCTIONALITY
Date and time

.LINK
https://en.wikipedia.org/wiki/Unix_time

.LINK
https://stackoverflow.com/a/1860511/54323

.LINK
Get-Date

.EXAMPLE
Get-Date |ConvertTo-EpochTime.ps1

1556884381
#>

#Requires -Version 3
[CmdletBinding()][OutputType([int])] Param(
# The DateTime value to convert to number of seconds since Jan 1, 1970.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][DateTime] $DateTime,
# Indicates the DateTime provided is local, and should be converted to UTC.
[Alias('UTC','Z')][switch] $UniversalTime
)
Process
{
    $value = [double]::Parse((Get-Date $(if($UniversalTime){$DateTime.ToUniversalTime()}else{$DateTime}) -UFormat %s))
    if($value -le [int]::MaxValue -and $value -ge [int]::MinValue) {return [int]$value}
    if($value -le [long]::MaxValue -and $value -ge [long]::MinValue) {return [long]$value}
    return $value
}
