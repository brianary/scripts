<#
.Synopsis
    Exports scheduled jobs as a PowerShell script that can be run to restore them.

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
        ContinueIfGoingOnBattery = $(!$Options.StopIfGoingOnBatteries |Format-PSLiterals.ps1)
        DoNotAllowDemandStart    = $($Options.DoNotAllowDemandStart |Format-PSLiterals.ps1)
        HideInTaskScheduler      = $(!$Options.ShowInTaskScheduler |Format-PSLiterals.ps1)
        IdleDuration             = $($Options.IdleDuration |Format-PSLiterals.ps1)
        IdleTimeout              = $($Options.IdleTimeout |Format-PSLiterals.ps1)
        MultipleInstancePolicy   = $([string]$Options.MultipleInstancePolicy |Format-PSLiterals.ps1)
        RequireNetwork           = $(!$Options.RunWithoutNetwork |Format-PSLiterals.ps1)
        RestartOnIdleResume      = $($Options.RestartOnIdleResume |Format-PSLiterals.ps1)
        RunElevated              = $($Options.RunElevated |Format-PSLiterals.ps1)
        StartIfIdle              = $(!$Options.StartIfNotIdle |Format-PSLiterals.ps1)
        StartIfOnBattery         = $($Options.StartIfOnBatteries |Format-PSLiterals.ps1)
        StopIfGoingOffIdle       = $($Options.StopIfGoingOffIdle |Format-PSLiterals.ps1)
        WakeToRun                = $($Options.WakeToRun |Format-PSLiterals.ps1)
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
                $user = if($trigger.User){" -User $($trigger.User |Format-PSLiterals.ps1)"}
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
        if($cmd.ContainsKey('FilePath')) {"FilePath             = $($cmd.FilePath |Format-PSLiterals.ps1)"}
        elseif($cmd.ContainsKey('ScriptBlock')) {"ScriptBlock          = $($cmd.ScriptBlock |Format-PSLiterals.ps1)"}
@"
@{
    Name                 = $($Job.Name |Format-PSLiterals.ps1)
    $FileOrScript
    ArgumentList         = $($cmd.ArgumentList |Format-PSLiterals.ps1)
    InitializationScript = $($cmd.InitializationScript |Format-PSLiterals.ps1)
    ScheduledJobOption   = $(Export-ScheduledJobOptions $Job.Options)
    Trigger              = $(($Job.JobTriggers |Export-ScheduledJobTrigger) -join ',')
    MaxResultCount       = $($Job.ExecutionHistoryLength)
    RunAs32              = $($cmd.RunAs32 |Format-PSLiterals.ps1)
    Authentication       = $($cmd.Authentication)
    Credential           = Get-Credential -Message $($Job.Name |Format-PSLiterals.ps1)
} |% {Register-ScheduledJob @_}
"@
}
}

Get-ScheduledJob |Export-ScheduledJob
