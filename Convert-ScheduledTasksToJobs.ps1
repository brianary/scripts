<#
.Synopsis
    Converts Scheduled Tasks to Scheduled Jobs.

.Parameter TaskPath
    Specifies the task path to export from.

.Link
    ConvertFrom-XmlElement.ps1

.Link
    Use-ReasonableDefaults.ps1

.Link
    Register-ScheduledJob

.Link
    New-ScheduledJobOption

.Link
    New-JobTrigger

.Link
    Disable-ScheduledTask

.Link
    Get-ScheduledTask

.Link
    Export-ScheduledTask

.Link
    Get-Credential

.Link
    Select-Xml

.Link
    ConvertTo-Json

.Example
    Convert-ScheduledTasksToJobs.ps1

    Converts PowerShell Scheduled Tasks in the \ path to Scheduled Jobs.
#>

#Requires -Version 5
#Requires -RunAsAdministrator
using module PSScheduledJob
using namespace System.Xml
[CmdletBinding(SupportsShouldProcess=$true)] Param(
[Parameter(Position=0)][string]$TaskPath = '\'
)

Use-ReasonableDefaults.ps1

function ConvertTo-TimeSpan([Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string]$Value)
{
    [XmlConvert]::ToTimeSpan($Value)
}

function Convert-XmlElementToJson([Parameter(Position=0,Mandatory=$true)][XmlElement]$XmlElement)
{
    $XmlElement |ConvertFrom-XmlElement.ps1 |ConvertTo-Json -Compress
}

function ConvertTo-JobTrigger
{
[CmdletBinding(SupportsShouldProcess=$true)] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][XmlElement]$Trigger
)
    Process
    {
        $params = @{}
        if($Trigger.RandomDelay) { $params += @{ RandomDelay = ConvertTo-TimeSpan $Trigger.RandomDelay } }
        if($Trigger.Enabled -and !([bool]::Parse($Trigger.Enabled))) { Write-Warning "Trigger is disabled"; return }
        switch($Trigger.Name)
        {
            BootTrigger
            {
                $params += @{ AtStartup = $true }
            }
            CalendarTrigger
            {
                $params += @{ At = Get-Date $Trigger.StartBoundary }
                switch((Select-Xml '*[starts-with(name(),"ScheduleBy")]' $Trigger).Node.Name)
                {
                    ScheduleByDay
                    {
                        $params += @{ Daily = $true }
                        if($Trigger.ScheduleByDay.DaysInterval)
                        {
                            $params += @{ DaysInterval = $Trigger.ScheduleByDay.DaysInterval }
                        }
                    }
                    ScheduleByMonth
                    {
                        Write-Warning "Unable to schedule monthly task trigger: $(Convert-XmlElementToJson $Trigger)"
                        return
                    }
                    ScheduleByMonthDayOfWeek
                    {
                        Write-Warning "Unable to schedule day of month task trigger: $(Convert-XmlElementToJson $Trigger)"
                        return
                    }
                    ScheduleByWeek
                    {
                        $params += @{
                            Weekly     = $true
                            DaysOfWeek = Select-Xml * $Trigger.ScheduleByWeek.DaysOfWeek |% {$_.Node.Name}
                        }
                        if($Trigger.ScheduleByWeek.WeeksInterval)
                        {
                            $params += @{ WeeksInterval = $Trigger.ScheduleByWeek.WeeksInterval }
                        }
                    }
                    default
                    {
                        Write-Warning "Unable to schedule calendar trigger: $(Convert-XmlElementToJson $Trigger)"
                        return
                    }
                }
            }
            LogonTrigger
            {
                $params += @{ AtLogOn = $true }
                if($Trigger.LogonTrigger.UserId)
                {
                    $params += @{ UserId = $Trigger.LogonTrigger.UserId }
                }
            }
            TimeTrigger
            {
                $params += @{ Once = $true; At = Get-Date $Trigger.StartBoundary }
                if($Trigger.Repetition)
                {
                    $params += @{ RepetitionInterval = ConvertTo-TimeSpan $Trigger.Repetition.Interval }
                    if($Trigger.Repetition.Duration)
                    {
                        $params += @{ RepetitionDuration = ConvertTo-TimeSpan $Trigger.Repetition.Duration }
                    }
                    else
                    {
                        $params += @{ RepeatIndefinitely = $true }
                    }
                }
            }
            default
            {
                Write-Warning "Unable to schedule trigger: $(Convert-XmlElementToJson $Trigger)"
                return
            }
        }
        Write-Verbose "Create trigger: $(ConvertTo-Json $params -Compress)"
        New-JobTrigger @params
    }
}

$CredentialCache = @{}
function Convert-ScheduledTaskToJob
{
[CmdletBinding(SupportsShouldProcess=$true)] Param(
[Parameter(Position=0,Mandatory=$true)][ciminstance]$Task,
[Parameter(Position=1,Mandatory=$true)]$Script,
[Parameter(Position=2)][string]$Argument
)
    [string]$userid = $Task.Principal.UserId
    if(!$CredentialCache.ContainsKey($userid)) {$CredentialCache[$userid] = Get-Credential $userid}
    $options = @{
        ContinueIfGoingOnBattery = !$Task.Settings.StopIfGoingOnBatteries
        DoNotAllowDemandStart    = !$Task.Settings.AllowDemandStart
        HideInTaskScheduler      = $Task.Settings.Hidden
        MultipleInstancePolicy   = $Task.Settings.MultipleInstances
        RequireNetwork           = $Task.Settings.RunOnlyIfNetworkAvailable
        RunElevated              = $Task.Principal.RunLevel -eq 'Highest'
        StartIfIdle              = $Task.Settings.RunOnlyIfIdle
        StartIfOnBattery         = !$Task.Settings.DisallowStartIfOnBatteries
        WakeToRun                = $Task.Settings.WakeToRun
    }
    if($options.StartIfIdle)
    {
        $options += @{
            IdleDuration        = ConvertTo-TimeSpan $Task.Settings.IdleSettings.IdleDuration
            IdleTimeout         = ConvertTo-TimeSpan $Task.Settings.IdleSettings.WaitTimeout
            StopIfGoingOffIdle  = $Task.Settings.IdleSettings.StopOnIdleEnd
            RestartOnIdleResume = $Task.Settings.IdleSettings.RestartOnIdle
        }
    }
    $argumentList = $Argument.Trim() -split '(?<=^[^"]*(?:"[^"]*"[^"]*)*)\s+'
    $params = @{
        Name         = $Task.TaskName
        Credential   = $CredentialCache[$userid]
        ScheduledJobOption = New-ScheduledJobOption @options
    }
    [Xml.XmlElement]$triggers = Export-ScheduledTask $Task.TaskName |Select-Xml /task:Task/task:Triggers |% Node
    if($triggers.ChildNodes.Count -eq 0){Write-Warning "Task $($Task.TaskName) has no triggers."}
    else
    {
        $trigger = $triggers.ChildNodes |ConvertTo-JobTrigger
        if($trigger) { $params += @{ Trigger = $trigger } }
    }
    $params +=
        if($Script -is [string]) {@{ FilePath = $Script.Trim('"') }}
        elseif($Script -is [ScriptBlock]) {@{ ScriptBlock = $Script }}
    if($argumentList) {$params['ArgumentList']= $argumentList}
    if($PSCmdlet.ShouldProcess($Task.TaskName,'disable scheduled task'))
    {
        Disable-ScheduledTask $Task.TaskName
    }
    if($PSCmdlet.ShouldProcess((ConvertTo-Json $params -Compress),'register scheduled job'))
    {
        Register-ScheduledJob @params
    }
}

function Convert-ScheduledTask
{
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][ciminstance]$Task
)
    Begin
    {
$FilePathParam = @'
(?ix)                      (?# case-insensitive, extended syntax )
(?:^|(?<=\s))              (?# following either the start of the string or a space )
-F(?:i(?:le?)?)? \s+       (?# -File param, or any accepted abbreviations of it )
(?<FilePath>\S+|"[^"]+")   (?# the script file path: spaceless, or quoted )
(?<Params>.*)              (?# followed by any parameters for the script )
'@
$CommandParam = @'
(?ix)                                    (?# case-insensitive, extended syntax )
(?:^|(?<=\s))                            (?# following either the start of the string or a space )
-C(?:o(?:m(?:m(?:a(?:nd?)?)?)?)?)? \s+   (?# -Command param, or any accepted abbreviations of it )
(?<ScriptBlock>\S+|"[^"]+"|\{[^}]*\})    (?# the script block: spaceless, quoted, or brace-delimited )
(?<Params>.*)                            (?# followed by any parameters for the script )
'@
    }
    Process
    {
        if($Task.Actions.Count -ne 1)
        {
            Write-Warning "Task '$($Task.TaskName)' has $($Task.Actions.Count) actions, skipping."
            return
        }
        $a = $Task.Actions[0]
        if((Split-Path $a.Execute -Leaf) -ne 'powershell.exe')
        {
            Write-Verbose "Task '$($Task.TaskName)' is not a PowerShell task."
        }
        elseif($a.Arguments -match $FilePathParam)
        {
            $workdir,$filepath = $a.WorkingDirectory,$Matches.FilePath.Trim('"')
            Write-Verbose "Converting '$($Task.TaskName)' as a PowerShell file task ($filePath; $workdir)."
            $file =
                if([io.path]::IsPathRooted($filepath)) {$filepath}
                else { [io.path]::Combine($workdir,$filepath) }
            Convert-ScheduledTaskToJob $Task $file $Matches.Params
        }
        elseif($a.Arguments -match $CommandParam)
        {
            Write-Verbose "Converting '$($Task.TaskName)' as a PowerShell command task."
            $block = [ScriptBlock]::Create(($Matches.ScriptBlock -replace '^\s*["{]|[}"]\s*$',''))
            Convert-ScheduledTaskToJob $Task $block $Matches.Params
        }
        else
        {
            Write-Warning "Task '$($Task.TaskName)' is not a recognized PowerShell task: $($a.Arguments)"
        }
    }
}

Get-ScheduledTask -TaskPath $TaskPath |Convert-ScheduledTask
