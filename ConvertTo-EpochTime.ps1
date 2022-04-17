<#
.SYNOPSIS
Converts a DateTime value into an integer Unix (POSIX) time, seconds since Jan 1, 1970.

.PARAMETER DateTime
The DateTime value to convert to number of seconds since Jan 1, 1970.

.PARAMETER UniversalTime
Indicates the DateTime provided is local, and should be converted to UTC.

.INPUTS
System.DateTime values to convert to integers.

.OUTPUTS
System.Int32 values converted from date and time values.

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

[CmdletBinding()][OutputType([int])] Param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][DateTime] $DateTime,
[Alias('UTC')][switch] $UniversalTime
)
Process{[int][double]::Parse((Get-Date $(if($UniversalTime){$DateTime.ToUniversalTime()}else{$DateTime}) -UFormat %s))}
