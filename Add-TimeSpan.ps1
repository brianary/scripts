<#
.Synopsis
    Adds a timespan to DateTime values.

.Parameter TimeSpan
    The TimeSpan value to add.

.Parameter DateTime
    The DateTime value to add to.

.Inputs
    System.DateTime values to add the TimeSpan value to.

.Outputs
    System.DateTime values with the TimeSpan added.

.Example
    Get-Date |Add-TimeSpan.ps1 00:00:30

    Adds 30 seconds to the current date and time value.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([DateTime])] Param(
[Parameter(Mandatory=$true)][TimeSpan]$TimeSpan,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][DateTime]$DateTime
)
Process{$DateTime.Add($TimeSpan)}
