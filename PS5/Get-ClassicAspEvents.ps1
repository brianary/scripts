<#
.SYNOPSIS
Gets Classic ASP errors from the event log on the given server.

.OUTPUTS
System.Diagnostics.EventLogEntry of Classic ASP events.
#>

#requires -version 3
[CmdletBinding()][OutputType([System.Diagnostics.EventLogEntry])] Param(
# The name of the server on which the error occurred.
[Parameter(Position=0)][Alias('CN','Server')][string[]]$ComputerName = $env:COMPUTERNAME,
# Gets only events with the specified entry type. Valid values are Error, Information, and Warning. The default is all events.
[ValidateSet('Information','Warning','Error')][string[]]$EntryType,
# Skip events older than this datetime.
[DateTime]$After,
# Skip events newer than this datetime.
[DateTime]$Before,
# The maximum number of the most recent events to return.
[int]$Newest
)
$EventQuery = @{
    ComputerName = $ComputerName
    LogName      = 'Application'
    Source       = 'Active Server Pages'
}
if($After){$EventQuery.After=$After}
if($Before){$EventQuery.Before=$Before}
if($Newest){$EventQuery.Newest=$Newest}
if($EntryType){$EventQuery.EntryType=$EntryType}
Get-EventLog @EventQuery
