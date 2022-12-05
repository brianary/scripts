<#
.SYNOPSIS
Converts supported objects to the RFC 5545 iCalendar format.

.NOTES
This is still a work in progress.

.INPUTS
Microsoft.Management.Infrastructure.CimInstance of CIM class MSFT_ScheduledTask, as
returned by Get-ScheduledTask.

.OUTPUTS
System.String containing iCalendar data.

.FUNCTIONALITY
Scheduled Tasks

.LINK
http://webcoder.info/recurrence.html

.LINK
https://datatracker.ietf.org/doc/html/rfc5545

.LINK
https://wutils.com/wmi/root/microsoft/windows/taskscheduler/msft_scheduledtask/

.LINK
https://docs.microsoft.com/windows-server/administration/windows-commands/schtasks-query

.LINK
https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/cc725744%28v=ws.11%29

.LINK
Use-Command.ps1

.LINK
ConvertFrom-CimInstance.ps1

.LINK
ConvertFrom-XmlElement.ps1

.LINK
New-ScheduledTaskTrigger

.LINK
Get-Date

.EXAMPLE
Get-ScheduledTask -TaskPath \ |ConvertTo-ICalendar.ps1 |Out-File tasks.ical utf8
#>

#Requires -Version 7
#Requires -Modules ScheduledTasks
[CmdletBinding()][OutputType([string])] Param(
# A CimInstance of MSFT_ScheduledTask, as output by Get-ScheduledTask.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_ScheduledTask'})]
[Microsoft.Management.Infrastructure.CimInstance] $ScheduledTask,
# The time zone to use in the iCalendar data.
[ValidateScript({$_.HasIanaId})][TimeZoneInfo] $TimeZone = (Get-TimeZone |ForEach-Object {[string]$tzid = 'UTC'
	[void][TimeZoneInfo]::TryConvertWindowsIdToIanaId($_.Id, [ref]$tzid); Get-TimeZone -Id $tzid}),
# For tasks without an explicit duration, use this as the duration in the iCalendar events.
[TimeSpan] $DefaultTaskDuration = '00:01:00'
)
Begin
{
	Use-Command.ps1 schtasks C:\windows\system32\schtasks.exe -Message 'Unable to locate schtasks.exe'
	Set-Variable MonthNames ((Get-Culture -Name '').DateTimeFormat.MonthGenitiveNames) `
		-Scope Script -Option Constant -Description 'Month names, invariant culture'

	filter ConvertTo-DateTimeStamp
	{
		[CmdletBinding()][OutputType([string])] Param([Parameter(ValueFromPipelineByPropertyName=$true)][psobject]$Date)
		if($null -eq $Date) {Get-Date (Get-Date).ToUniversalTime() -f yyyyMMdd\THHmmssZ}
		else {Get-Date (Get-Date $Date).ToUniversalTime() -f yyyyMMdd\THHmmssZ}
	}

	function ConvertTo-DateTimeWithZone
	{
		[CmdletBinding()][OutputType([string])] Param(
		[datetime] $Value,
		[TimeZoneInfo] $TimeZone
		)
		return "TZID=$($TimeZone.Id):$(Get-Date $value -f yyyyMMdd\THHmmss)"
	}

	function ConvertFrom-SimpleInterval
	{
		[CmdletBinding()][OutputType([string])] Param(
		[ValidatePattern('\AP\d+[YMD]|T\d+[HMS]\z',ErrorMessage='A simple (single-unit) ISO8601 duration is required')]
		[Parameter(Position=0,Mandatory=$true)][string] $Interval
		)
		$Interval -match '\d+' |Out-Null
		[int] $value = $Matches[0]
		$frequency = switch -Regex ($Interval)
		{
			'P\d+Y' {'YEARLY'}
			'P\d+M' {'MONTHLY'}
			'P\d+D' {'DAILY'}
			'PT\d+H' {'HOURLY'}
			'PT\d+M' {'MINUTELY'}
			'PT\d+S' {'SECONDLY'}
		}
		return "`r`nRRULE:FREQ=$frequency;INTERVAL=$value"
	}

	function ConvertFrom-TaskDailyTrigger
	{
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(Mandatory=$true)][ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_TaskDailyTrigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger
		)
		return "`r`nRRULE:FREQ=DAILY;INTERVAL=$($TaskTrigger.DaysInterval)"
	}

	function ConvertFrom-TaskWeeklyTrigger
	{
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(Mandatory=$true)]
		[ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_TaskWeeklyTrigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger
		)
		if($TaskTrigger.DaysOfWeek -in 0,0x7F)
		{
			return "`r`nRRULE:FREQ=WEEKLY;INTERVAL=$($TaskTrigger.WeeksInterval)"
		}
		else
		{
			$byday = @(switch($TaskTrigger.DaysOfWeek)
			{
				{$_ -band 0x01}{'SU'}
				{$_ -band 0x02}{'MO'}
				{$_ -band 0x04}{'TU'}
				{$_ -band 0x08}{'WE'}
				{$_ -band 0x10}{'TH'}
				{$_ -band 0x20}{'FR'}
				{$_ -band 0x40}{'SA'}
			}) -join ','
			return "`r`nRRULE:FREQ=WEEKLY;INTERVAL=$($TaskTrigger.WeeksInterval);BYDAY=$byday"
		}
	}

	function ConvertFrom-TaskMonthlyDOWTrigger
	{
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(Mandatory=$true)][ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_TaskMonthlyDOWTrigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger
		)
		return "`r`nRRULE:FREQ=MONTHLY;BYDAY=$($TaskTrigger.DaysOfWeek)"
	}

	function ConvertFrom-TaskMonthlyTrigger
	{
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(Mandatory=$true)][ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_TaskMonthlyTrigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger
		)
		return "`r`nRRULE:FREQ=MONTHLY;BYMONTHDAY=$($TaskTrigger.DaysOfMonth)"
	}

	filter ConvertFrom-ScheduleByMonth
	{
		[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter','',
		Justification='Script analysis is missing the usage of Months.')]
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(ValueFromPipelineByPropertyName=$true)][psobject] $Months,
		[Parameter(ValueFromPipelineByPropertyName=$true)][psobject] $DaysOfMonth
		)
		[int[]] $monthNums = 1..12 |Where-Object {$Months.PSObject.Properties.Match($MonthNames[$_-1])}
		$days = switch("$($DaysOfMonth.Day)"){Last{'BYSETPOS=-1'}default{"BYDAY=$($DaysOfMonth.Day -join ',')"}}
		if($monthNums.Count -eq 12)
		{
			return "`r`nRRULE:FREQ=MONTHLY;INTERVAL=1;$days"
		}
		else
		{
			return "`r`nRRULE:FREQ=YEARLY;INTERVAL=1;BYMONTH=$($monthNums -join ',');$days"
		}
	}

	filter ConvertFrom-ScheduleByMonthDayOfWeek
	{
		[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter','',
		Justification='Script analysis is missing the usage of Months.')]
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(ValueFromPipelineByPropertyName=$true)][psobject] $Months,
		[Parameter(ValueFromPipelineByPropertyName=$true)][psobject] $Weeks,
		[Parameter(ValueFromPipelineByPropertyName=$true)][psobject] $DaysOfWeek
		)
		[int[]] $monthNums = 1..12 |Where-Object {$Months.PSObject.Properties.Match($MonthNames[$_-1])}
		$pos = @(switch($Weeks.Week){Last{-1}default{$_}})
		$days = $DaysOfWeek.PSObject.Properties.Match('*').Name |
			ForEach-Object {$_.Substring(0,3).ToUpperInvariant()}
		$posdays = "BYDAY=$((Format-Permutations.ps1 -Format '{0}{1}' -InputObject $pos,$days) -join ',')"
		if($posdays -eq 'BYDAY=Last') {$posdays = 'BYSETPOS=-1'}
		if($monthNums.Count -eq 12)
		{
			return "`r`nRRULE:FREQ=MONTHLY;INTERVAL=1;$posdays"
		}
		else
		{
			return "`r`nRRULE:FREQ=YEARLY;INTERVAL=1;BYMONTH=$($monthNums -join ',');$posdays"
		}
	}
	filter ConvertFrom-TaskTrigger
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][string] $TaskName,
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
		[ValidateScript({$_.CimClass.CimClassName -like 'MSFT_Task*Trigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
		[Alias('StartBoundary')][datetime] $Start,
		[TimeSpan] $DefaultTaskDuration,
		[TimeZoneInfo] $TimeZone
		)
		if(!$TaskTrigger.Enabled) {Write-Warning "Disabled $($TaskTrigger.CimClass.CimClassName) will be ignored"; return}
		$end = $null -eq $TaskTrigger.Repetition.Duration ? $Start.Add($DefaultTaskDuration) :
			$Start.Add([Xml.XmlConvert]::ToTimeSpan($TaskTrigger.Repetition.Duration))
		$schedule = @"
DTSTART;$(ConvertTo-DateTimeWithZone -Value $Start -TimeZone $TimeZone)
DTEND;$(ConvertTo-DateTimeWithZone -Value $end -TimeZone $TimeZone)
"@
		switch($TaskTrigger.CimClass.CimClassName)
		{
			MSFT_TaskDailyTrigger {$schedule += ConvertFrom-TaskDailyTrigger $TaskTrigger}
			MSFT_TaskWeeklyTrigger {$schedule += ConvertFrom-TaskWeeklyTrigger $TaskTrigger}
			# MSFT_TaskMonthlyDOWTrigger {$schedule += ConvertFrom-TaskMonthlyDOWTrigger $TaskTrigger}
			# MSFT_TaskMonthlyTrigger {$schedule += ConvertFrom-TaskMonthlyTrigger $TaskTrigger}
			{$_ -eq 'MSFT_TaskTimeTrigger' -and $null -ne $TaskTrigger.Repetition.Interval}
			{$schedule += ConvertFrom-SimpleInterval $TaskTrigger.Repetition.Interval}
			MSFT_TaskTrigger
			{
				Write-Verbose "CIM object contains no useful scheduling data; reading via schtasks XML"
				$task = [xml](schtasks /query /xml /tn $TaskName) |ConvertFrom-XmlElement.ps1
				$task.Triggers |
					Where-Object {$_.PSObject.Properties.Match('CalendarTrigger').Count -eq 0} |
					ConvertTo-Json -Compress -Depth 5 |
					ForEach-Object {Write-Warning "Ignoring non-calendar trigger: $_"}
				$calendarTrigger = @($task.Triggers |
					Where-Object {$_.PSObject.Properties.Match('CalendarTrigger').Count -gt 0} |
					ForEach-Object CalendarTrigger)
				$calendarTrigger |
					Where-Object {$_.PSObject.Properties.Match('ScheduleByMonth*').Count -eq 0} |
					ConvertTo-Json -Compress -Depth 5 |
					ForEach-Object {Write-Warning "Ignoring non-month calendar trigger: $_"}
				$schedule += $calendarTrigger |
					Where-Object {$_.PSObject.Properties.Match('ScheduleByMonth').Count -gt 0} |
					ForEach-Object ScheduleByMonth |
					ConvertFrom-ScheduleByMonth
				$schedule += $calendarTrigger |
					Where-Object {$_.PSObject.Properties.Match('ScheduleByMonthDayOfWeek').Count -gt 0} |
					ForEach-Object ScheduleByMonthDayOfWeek |
					ConvertFrom-ScheduleByMonthDayOfWeek
			}
			default {Write-Warning "$_ will be ignored"}
		}
		return $schedule
	}

	$ical = @"
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//webcoder.info//$($MyInvocation.MyCommand.Name)//EN

"@
}
Process
{
	$ical += @"
BEGIN:VEVENT
UID:$(New-Guid)
DTSTAMP:$($ScheduledTask |ConvertTo-DateTimeStamp)
$($ScheduledTask.Triggers |ConvertFrom-TaskTrigger -TaskName $ScheduledTask.TaskName `
	-DefaultTaskDuration $DefaultTaskDuration -TimeZone $TimeZone)
SUMMARY:$($ScheduledTask.TaskName)
DESCRIPTION:$($ScheduledTask.Description)
END:VEVENT

"@
}
End
{
	$ical += @"
END:VCALENDAR

"@
	return $ical
}
