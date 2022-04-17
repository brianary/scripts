<#
.SYNOPSIS
Adds a timespan to DateTime values.

.PARAMETER TimeSpan
The TimeSpan value to add.

.PARAMETER DateTime
The DateTime value to add to.

.INPUTS
System.DateTime values to add the TimeSpan value to.

.OUTPUTS
System.DateTime values with the TimeSpan added.

.EXAMPLE
Get-Date |Add-TimeSpan.ps1 00:00:30

Adds 30 seconds to the current date and time value.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([DateTime])] Param(
[Parameter(Mandatory=$true)][TimeSpan]$TimeSpan,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][DateTime]$DateTime
)
Process{$DateTime.Add($TimeSpan)}
