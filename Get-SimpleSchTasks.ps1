<#
.SYNOPSIS
Returns simple scheduled task info.

.FUNCTIONALITY
Scheduled Tasks

.EXAMPLE
Get-SimpleSchTasks.ps1 -TaskPath \ -NonInteractive

Returns a simplified list of tasks for the local system that are not set to run interactively.
#>

#Requires -Version 7
[CmdletBinding()] Param(
# Specifies an array of one or more names of a scheduled task. You can use "*" for a wildcard character query.
[Parameter(Position=0)][string[]] $TaskName,
# Specifies an array of one or more paths for scheduled tasks in Task Scheduler namespace.
# You can use "*" for a wildcard character query. You can use \ for the root folder.
# To specify a full TaskPath you need to include the leading and trailing \ *.
# If you do not specify a path, the cmdlet uses the root folder.
[Parameter(Position=1)][string[]] $TaskPath,
# Exclude tasks that are set to run interactively, include only tasks with credentials set.
[switch] $NonInteractive
)
Begin
{
	filter Get-ComHandler
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipelineByPropertyName=$true)][string] $ClassId,
		[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Data
		)
		return "CLSID:$ClassId $Data"
	}
	filter Get-ExecAction
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipelineByPropertyName=$true)][string] $WorkingDirectory,
		[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Execute,
		[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Arguments
		)
		return '{0}> {1} {2}' -f (($WorkingDirectory ? $WorkingDirectory : "%SystemRoot%\system32"),
			($Execute -replace '\A([^"].*\s.*)\z','"$1"'),$Arguments |
			ForEach-Object {[Environment]::ExpandEnvironmentVariables($_)})
	}
	filter Get-Run
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipeline=$true)][Microsoft.Management.Infrastructure.CimInstance] $Action
		)
		switch($Action.CimClass.CimClassName)
		{
			MSFT_TaskComHandlerAction {$Action |Get-ComHandler}
			MSFT_TaskExecAction {$Action |Get-ExecAction}
			default {"${_}: $($Action |Select-Object -ExcludeProperty Id,PSComputerName,Cim* |ConvertTo-Json -Compress -Depth 1)"}
		}
	}
	function Get-Weekdays
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0)][ushort] $DaysOfWeek
		)
		if($DaysOfWeek -band 0b1) {[dayofweek]::Sunday}
		if($DaysOfWeek -band 0b10) {[dayofweek]::Monday}
		if($DaysOfWeek -band 0b100) {[dayofweek]::Tuesday}
		if($DaysOfWeek -band 0b1000) {[dayofweek]::Wednesday}
		if($DaysOfWeek -band 0b10000) {[dayofweek]::Thursday}
		if($DaysOfWeek -band 0b100000) {[dayofweek]::Friday}
		if($DaysOfWeek -band 0b1000000) {[dayofweek]::Saturday}
	}
	filter Get-StateChange
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipelineByPropertyName=$true)][string] $UserId,
		[Parameter(ValueFromPipelineByPropertyName=$true)][uint] $StateChange
		)
		$username = "$($UserId ? $UserId : 'any user')"
		switch($StateChange)
		{
			3 {"On remote connection to user session of $username"}
			4 {"On remote disconnect from user session of $username"}
			7 {"On workstation lock of $username"}
			8 {"On workstation unlock of $username"}
			default {"On state change #$_ of $username"}
		}
	}
	filter Get-Schedule
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipeline=$true)][Microsoft.Management.Infrastructure.CimInstance] $Trigger
		)
		if(!$Trigger -or !$Trigger.Enabled) {return}
		switch($Trigger.CimClass.CimClassName)
		{
			MSFT_TaskTimeTrigger
			{
				if(!$Trigger.Repetition.Interval) {$Trigger.StartBoundary}
				else {'R/{0:yyyy-MM-ddTHH:mm:ss}/{1}' -f $Trigger.StartBoundary,$Trigger.Repetition.Interval}
			}
			MSFT_TaskWeeklyTrigger
			{
				$start = Get-Date $Trigger.StartBoundary
				foreach($day in Get-Weekdays $Trigger.DaysOfWeek)
				{
					'R/{0:yyyy-MM-ddTHH:mm:ss}/P{1}W' -f `
						$start.AddDays(($start.DayOfWeek - $day) + ($start.DayOfWeek -ge $day ? 0 : 7)),
						$Trigger.WeeksInterval
				}
			}
			MSFT_TaskDailyTrigger {'R/{0:yyyy-MM-ddTHH:mm:ss}/P1D' -f $Trigger.StartBoundary}
			MSFT_TaskLogonTrigger {"At log on of $($Trigger.UserId ?? 'any user')"}
			MSFT_TaskBootTrigger {'At startup'}
			MSFT_TaskIdleTrigger {'On idle'}
			MSFT_TaskTrigger {'At task creation/modification'}
			MSFT_TaskSessionStateChangeTrigger {$Trigger |Get-Member -Type Properties |Write-Debug; $Trigger |Get-StateChange}
			MSFT_TaskRegistrationTrigger {'When the task is created or modified'}
			# MSFT_TaskEventTrigger {$Trigger.Subscription; "On event - Log: $log, Source: $source, Event ID: $eventid"}
			default {$Trigger |Get-Member -Type Properties |Write-Debug; $_}
		}
	}
	filter Get-SimpleTask
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipeline=$true)][Microsoft.Management.Infrastructure.CimInstance] $Task
		)
        $info = Get-ScheduledTaskInfo -TaskName $Task.TaskName -TaskPath $task.TaskPath
		return [pscustomobject]@{
			TaskName       = $Task.TaskName
            Enabled        = $Task.{Settings}?.Enabled
			User           = $Task.Principal.UserId
			LastRunTime    = $info.LastRunTime
			LastTaskResult = $info.LastTaskResult
			Run            = $Task.Actions |Get-Run
			Schedule       = $Task.Triggers |Get-Schedule
		}
	}
}
Process
{
	$ScheduledTask = @{}
	if($TaskName) {$ScheduledTask['TaskName'] = $TaskName}
	if($TaskPath) {$ScheduledTask['TaskPath'] = $TaskPath}
	$tasks = Get-ScheduledTask @ScheduledTask
	if($NonInteractive) {$tasks = $tasks |Where-Object {$_.Principal.LogonType -eq 1}}
	$tasks |Get-SimpleTask
}
