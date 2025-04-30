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
$ScheduledTask = @{}
if($TaskName) {$ScheduledTask['TaskName'] = $TaskName}
if($TaskPath) {$ScheduledTask['TaskPath'] = $TaskPath}
$tasks = Get-ScheduledTask @ScheduledTask
if($NonInteractive) {$tasks = $tasks |Where-Object {$_.Principal.LogonType -eq 1}}
foreach($task in $tasks)
{
    $info = Get-ScheduledTaskInfo -TaskName $task.TaskName
    [pscustomobject]@{
        TaskName       = $task.TaskName
        Enabled        = $task.Triggers.Enabled -and $task.Settings.Enabled
        User           = $task.Principal.UserId
        LastRunTime    = $info.LastRunTime
        ListTaskResult = $info.LastTaskResult
        Run            = '{0}> {1} {2}' -f (($task.Actions.WorkingDirectory ?? "%SystemRoot%\system32"),
            ($task.Actions.Execute -replace '\A([^"].*\s.*)\z','"$1"'),
            $task.Actions.Arguments |ForEach-Object {[Environment]::ExpandEnvironmentVariables($_)})
        Schedule       = switch($task.Triggers.CimClass.CimClassName)
        {
            MSFT_TaskTimeTrigger {'R/{0:yyyy-MM-ddTHH:mm:ss}/{1}' -f $task.Triggers.StartBoundary,$task.Triggers.Repetition.Interval}
            default {$_}
        }
    }
}
