<#
.SYNOPSIS
Converts an integer Unix (POSIX) time (seconds since Jan 1, 1970) into a DateTime value.

.INPUTS
System.Int32 value converted from date and time value.

.OUTPUTS
System.DateTime value to convert to integer.

.FUNCTIONALITY
Date and time

.LINK
https://en.wikipedia.org/wiki/Unix_time

.LINK
https://stackoverflow.com/a/1860511/54323

.LINK
Get-Date

.EXAMPLE
1556884381 |ConvertFrom-EpochTime.ps1

Friday, May 3, 2019 11:53:01
#>

#Requires -Version 3
[CmdletBinding()][OutputType([int])] Param(
# The Epoch time value to convert to a DateTime.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][long] $InputObject,
# Indicates the DateTime provided is local, and should be converted to UTC.
[Alias('UTC','Z')][switch] $UniversalTime
)
Process{(Get-Date 1970-01-01 -AsUTC:$UniversalTime).AddSeconds($InputObject)}
