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

.LINK
https://datatracker.ietf.org/doc/html/rfc5545

.LINK
https://wutils.com/wmi/root/microsoft/windows/taskscheduler/msft_scheduledtask/

.EXAMPLE
Get-ScheduledTask -TaskPath \ |ConvertTo-ICalendar.ps1 |Out-File tasks.ical utf8
#>

#Requires -Version 7
[CmdletBinding()][OutputType([string])] Param(
# A CimInstance of MSFT_ScheduledTask, as output by Get-ScheduledTask.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
[ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_ScheduledTask'})]
[Microsoft.Management.Infrastructure.CimInstance] $ScheduledTask,
[ValidateScript({$_.HasIanaId})][TimeZoneInfo] $TimeZone = (Get-TimeZone |ForEach-Object {[string]$tzid = 'UTC'
	[void][TimeZoneInfo]::TryConvertWindowsIdToIanaId($_.Id, [ref]$tzid); Get-TimeZone -Id $tzid}),
[TimeSpan] $DefaultTaskDuration = '00:01:00'
)
Begin
{
	Write-Warning "This is still a work in progress."

	Use-Command.ps1 schtasks C:\windows\system32\schtasks.exe -Message 'Unable to locate schtasks.exe'

	function ConvertTo-DateTimeStamp([Parameter(ValueFromPipelineByPropertyName=$true)][psobject]$Date)
	{
		if($null -eq $Date) {Get-Date (Get-Date).ToUniversalTime() -f yyyyMMdd\THHmmssZ}
		else {Get-Date (Get-Date $Date).ToUniversalTime() -f yyyyMMdd\THHmmssZ}
	}

	function ConvertTo-DateTimeWithZone([datetime]$value)
	{
		return "TZID=$($TimeZone.Id):$(Get-Date $value -f yyyyMMdd\THHmmss)"
	}

	function ConvertFrom-SimpleInterval
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][ValidatePattern('\AP\d+[YMD]|T\d+[HMS]\z')]
		[string] $Interval
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
		[CmdletBinding()] Param(
		[Parameter(Mandatory=$true)][ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_TaskDailyTrigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger
		)
		return "`r`nRRULE:FREQ=DAILY;INTERVAL=$($TaskTrigger.DaysInterval)"
	}
	function ConvertFrom-TaskMonthlyDOWTrigger
	{
		[CmdletBinding()] Param(
		[Parameter(Mandatory=$true)][ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_TaskMonthlyDOWTrigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger
		)
		return "`r`nRRULE:FREQ=MONTHLY;BYDAY=$($TaskTrigger.DaysOfWeek)"
	}
	function ConvertFrom-TaskMonthlyTrigger
	{
		[CmdletBinding()] Param(
		[Parameter(Mandatory=$true)][ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_TaskMonthlyTrigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger
		)
		return "`r`nRRULE:FREQ=MONTHLY;BYMONTHDAY=$($TaskTrigger.DaysOfMonth)"
	}
	function ConvertFrom-TaskWeeklyTrigger
	{
		[CmdletBinding()] Param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
		[ValidateScript({$_.CimClass.CimClassName -eq 'MSFT_TaskWeeklyTrigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger
		)
		return "`r`nRRULE:FREQ=WEEKLY;BYDAY=$($TaskTrigger.DaysOfWeek)"
	}
	function ConvertFrom-TaskTrigger
	{
		[CmdletBinding()] Param(
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
		[ValidateScript({$_.CimClass.CimClassName -like 'MSFT_Task*Trigger'})]
		[Microsoft.Management.Infrastructure.CimInstance] $TaskTrigger,
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
		[Alias('StartBoundary')][datetime] $Start
		)
		if(!$TaskTrigger.Enabled) {Write-Warning "Disabled $($TaskTrigger.CimClass.CimClassName) will be ignored"; return}
		$end = $null -eq $TaskTrigger.Repetition.Duration ? $Start.Add($DefaultTaskDuration) :
			$Start.Add([Xml.XmlConvert]::ToTimeSpan($TaskTrigger.Repetition.Duration))
		$schedule = @"
DTSTART;$(ConvertTo-DateTimeWithZone $Start)
DTEND;$(ConvertTo-DateTimeWithZone $end)
"@
		Write-Debug $TaskTrigger.CimClass.CimClassName
		$TaskTrigger |ConvertFrom-CimInstance.ps1 |ConvertTo-Json -Depth 4 |Write-Debug
		switch($TaskTrigger.CimClass.CimClassName)
		{
			MSFT_TaskDailyTrigger {$schedule += ConvertFrom-TaskDailyTrigger $TaskTrigger}
			MSFT_TaskMonthlyDOWTrigger {$schedule += ConvertFrom-TaskMonthlyDOWTrigger $TaskTrigger}
			MSFT_TaskMonthlyTrigger {$schedule += ConvertFrom-TaskMonthlyTrigger $TaskTrigger}
			{$_ -eq 'MSFT_TaskTimeTrigger' -and $null -ne $TaskTrigger.Repetition.Interval}
			{$schedule += ConvertFrom-SimpleInterval $TaskTrigger.Repetition.Interval}
			MSFT_TaskWeeklyTrigger {$schedule += ConvertFrom-TaskWeeklyTrigger $TaskTrigger}
			MSFT_TaskTrigger
			{
				Write-Warning "CIM object contains no useful scheduling data; reading via schtasks XML"
				$task = [xml](schtasks /query /xml /tn $TaskTrigger.TaskName) |ConvertFrom-XmlElement.ps1
				$task |ConvertTo-Json -Depth 4 |Write-Host
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
$($ScheduledTask.Triggers |ConvertFrom-TaskTrigger)
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
