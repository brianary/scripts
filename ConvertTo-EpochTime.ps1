<#
.Synopsis
    Converts a DateTime value into an integer Unix (POSIX) time, seconds since Jan 1, 1970.

.Parameter DateTime
    The DateTime value to convert to number of seconds since Jan 1, 1970.

.Inputs
    System.DateTime values to convert to integers.

.Outputs
    System.Int32 values converted from date and time values.

.Link
    https://en.wikipedia.org/wiki/Unix_time

.Link
    https://stackoverflow.com/a/1860511/54323

.Link
    Get-Date

.Example
    Get-Date |ConvertTo-EpochTime.ps1

    1556884381
#>

[CmdletBinding()][OutputType([int])] Param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][DateTime]$DateTime
)
Process{[int][double]::Parse((Get-Date $DateTime -UFormat %s))}
