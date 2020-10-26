<#
.Synopsis
	Exports scheduled jobs as a PowerShell script that can be run to restore them.

.Outputs
	Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition for each scheduled job.

.Link
    https://docs.microsoft.com/powershell/module/psscheduledjob/about/about_scheduled_jobs

.Link
    https://msdn.microsoft.com/library/microsoft.powershell.scheduledjob.scheduledjobdefinition_members.aspx

.Link
    Get-ScheduledJob

.Example
    Export-ScheduledJobs.ps1 |Out-File Import-ScheduledJobs.ps1 utf8

    Exports all scheduled jobs as PowerShell Register-ScheduledJob cmdlet strings.
#>

[CmdletBinding()][OutputType([Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition])] Param()

function Export-ScheduledJobOptions
{
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[Microsoft.PowerShell.ScheduledJob.ScheduledJobOptions]$Options)
Process
{@"

    @{
        ContinueIfGoingOnBattery = $(!$Options.StopIfGoingOnBatteries |ConvertTo-PowerShell.ps1)
        DoNotAllowDemandStart    = $($Options.DoNotAllowDemandStart |ConvertTo-PowerShell.ps1)
        HideInTaskScheduler      = $(!$Options.ShowInTaskScheduler |ConvertTo-PowerShell.ps1)
        IdleDuration             = $($Options.IdleDuration |ConvertTo-PowerShell.ps1)
        IdleTimeout              = $($Options.IdleTimeout |ConvertTo-PowerShell.ps1)
        MultipleInstancePolicy   = $([string]$Options.MultipleInstancePolicy |ConvertTo-PowerShell.ps1)
        RequireNetwork           = $(!$Options.RunWithoutNetwork |ConvertTo-PowerShell.ps1)
        RestartOnIdleResume      = $($Options.RestartOnIdleResume |ConvertTo-PowerShell.ps1)
        RunElevated              = $($Options.RunElevated |ConvertTo-PowerShell.ps1)
        StartIfIdle              = $(!$Options.StartIfNotIdle |ConvertTo-PowerShell.ps1)
        StartIfOnBattery         = $($Options.StartIfOnBatteries |ConvertTo-PowerShell.ps1)
        StopIfGoingOffIdle       = $($Options.StopIfGoingOffIdle |ConvertTo-PowerShell.ps1)
        WakeToRun                = $($Options.WakeToRun |ConvertTo-PowerShell.ps1)
    } |% {New-ScheduledJobOption @_}
"@}
}

function Export-ScheduledJobTrigger
{
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[Microsoft.PowerShell.ScheduledJob.ScheduledJobTrigger[]]$JobTriggers)
Process
{
    foreach($trigger in $JobTriggers)
    {
        $at = if($trigger.At){" -At $(Get-Date $trigger.At -Format yyyy-MM-ddTHH:mm:ss)"}
        $delay = if($trigger.RandomDelay -gt [timespan]::Zero){" -RandomDelay $($trigger.RandomDelay)"}
        switch($trigger.Frequency)
        {
            Once
            {
                $indef = if($trigger.RepeatIndefinitely){" -RepeatIndefinitely"}
                $duration = if($trigger.RepetitionDuration){" -RepeatDuration $($trigger.RepetitionDuration)"}
                $repeatevery = if($trigger.RepetitionInterval){" -RepetitionInterval $($trigger.RepetitionInterval)"}
                "(New-JobTrigger -Once$at$delay$indef$duration$repeatevery)"
            }
            Daily
            {
                $interval = if($trigger.Interval){" -DaysInterval $($trigger.Interval)"}
                "(New-JobTrigger -Daily$at$interval$delay)"
            }
            Weekly
            {
                $days = if($trigger.DaysOfWeek){" -DaysOfWeek $(($trigger.DaysOfWeek |% {"'$_'"}) -join ',')"}
                $interval = if($trigger.Interval){" -WeeksInterval $($trigger.Interval)"}
                "(New-JobTrigger -Weekly$at$days$interval$delay)"
            }
            AtLogon
            {
                $user = if($trigger.User){" -User $($trigger.User |ConvertTo-PowerShell.ps1)"}
                "(New-JobTrigger -AtLogon$user$delay)"
            }
            AtStartup {"(New-JobTrigger -AtStartup$delay)"}
        }
    }
}
}

function Export-ScheduledJob
{
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,ValueFromPipeline=$true)]
[Microsoft.PowerShell.ScheduledJob.ScheduledJobDefinition]$Job)
Process
{
    # InvocationInfo.Parameters is a List[CommandParameterCollection].
    # CommandParameterCollection contains CommandParameter name-value pairs which are not a hash.
    $cmd = @{}
    $Job.InvocationInfo.Parameters[0] |% {[void]$cmd.Add($_.Name,$_.Value)}
    $FileOrScript =
        if($cmd.ContainsKey('FilePath')) {"FilePath             = $($cmd.FilePath |ConvertTo-PowerShell.ps1)"}
        elseif($cmd.ContainsKey('ScriptBlock')) {"ScriptBlock          = $($cmd.ScriptBlock |ConvertTo-PowerShell.ps1)"}
@"
@{
    Name                 = $($Job.Name |ConvertTo-PowerShell.ps1)
    $FileOrScript
    ArgumentList         = $($cmd.ArgumentList |ConvertTo-PowerShell.ps1)
    InitializationScript = $($cmd.InitializationScript |ConvertTo-PowerShell.ps1)
    ScheduledJobOption   = $(Export-ScheduledJobOptions $Job.Options)
    Trigger              = $(($Job.JobTriggers |Export-ScheduledJobTrigger) -join ',')
    MaxResultCount       = $($Job.ExecutionHistoryLength)
    RunAs32              = $($cmd.RunAs32 |ConvertTo-PowerShell.ps1)
    Authentication       = $($cmd.Authentication)
    Credential           = Get-Credential -Message $($Job.Name |ConvertTo-PowerShell.ps1)
} |% {Register-ScheduledJob @_}
"@
}
}

Get-ScheduledJob |Export-ScheduledJob
