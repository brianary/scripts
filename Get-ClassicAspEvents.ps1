<#
.Synopsis
    Gets Classic ASP errors from the event log on the given server.

.Parameter ComputerName
    The name of the server on which the error occurred.

.Parameter EntryType
    Gets only events with the specified entry type. Valid values are Error, Information, and Warning. The default is all events.

.Parameter After
    Skip events older than this datetime.

.Parameter Before
    Skip events newer than this datetime.

.Parameter Newest
    The maximum number of the most recent events to return.
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0)][Alias('CN','Server')][string[]]$ComputerName = $env:COMPUTERNAME,
[ValidateSet('Information','Warning','Error')][string[]]$EntryType,
[DateTime]$After,
[DateTime]$Before,
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
