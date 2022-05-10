<#
.SYNOPSIS
Provides a human-readable view of a scheduled task returned by Get-ScheduledTasks.

.INPUTS
Microsoft.Management.Infrastructure.CimInstance returned from Get-ScheduledTask.

.OUTPUTS
System.Management.Automation.PSCustomObject describing each task, with the properties:

* PSComputerName
* TaskName
* State
* Action
* Trigger
* Description

.LINK
https://docs.microsoft.com/dotnet/api/microsoft.management.infrastructure.ciminstance

.LINK
Get-ScheduledTask

.EXAMPLE
Get-ScheduledTask |Show-ScheduledTask.ps1

(Returns a readable list of scheduled tasks.)
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
# A scheduled task, piped from Get-ScheduledTask.
[Parameter(ValueFromPipeline=$true)]
[ValidateScript({$_.CimClass -and $_.CimClass.CimClassName -eq 'MSFT_ScheduledTask'})]
[Microsoft.Management.Infrastructure.CimInstance]$Task
)
Begin
{
    filter Format-Action([Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [ValidateScript({$_.CimClass -and $_.CimClass.CimSuperClassName -eq 'MSFT_TaskAction'})]
        [Microsoft.Management.Infrastructure.CimInstance]$Action)
    {
        Import-Variables.ps1 $Action
        switch($Action.CimClass.CimClassName)
        {
            MSFT_TaskExecAction {"$WorkingDirectory> $Execute $Arguments"}
            default {"$($Action.CimClass.CimClassName): $(ConvertTo-Json $Action.CimInstanceProperties -Compress)"}
        }
    }

    filter Format-Trigger([Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [ValidateScript({$_.CimClass})][Microsoft.Management.Infrastructure.CimInstance]$Trigger)
    {
        Import-Variables.ps1 $Trigger
        $disabled = if(!$Enabled){' [disabled]'}
        switch($Trigger.CimClass.CimClassName)
        {
            MSFT_TaskTimeTrigger {"Once at $(Get-Date $StartBoundary -f 'ddd MMM dd, yyyy HH:mm:ss')$disabled"}
            MSFT_TaskDailyTrigger {"Daily at $(Get-Date $StartBoundary -f HH:mm:ss)$disabled"}
            MSFT_TaskWeeklyTrigger {"Weekly on $(Get-Date $StartBoundary -f 'ddd \a\t HH:mm:ss')$disabled"}
            default {"$($Trigger.CimClass.CimClassName): $(ConvertTo-Json $Trigger -Compress)"}
        }
    }
}
Process
{
    Import-Variables.ps1 $Task
    [pscustomobject]@{
        PSComputerName = $PSComputerName
        TaskName       = $TaskName
        State          = $State
        Action         = ($Actions |Format-Action) -join "`n"
        Trigger        = if($Triggers) {($Triggers |Format-Trigger) -join "`n"} else {'(none)'}
        Description    = $Description
    }
}
