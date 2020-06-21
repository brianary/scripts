<#
.Synopsis
    Provides a human-readable view of a scheduled task returned by Get-ScheduledTasks.

.Parameter Task
    A scheduled task, piped from Get-ScheduledTask.

.Inputs
	Microsoft.Management.Infrastructure.CimInstance returned from Get-ScheduledTask.

.Outputs
	System.Management.Automation.PSCustomObject describing each task, with the properties:

		* PSComputerName
		* TaskName
		* State
		* Action
		* Trigger
		* Description

.Link
    https://docs.microsoft.com/dotnet/api/microsoft.management.infrastructure.ciminstance

.Link
    Get-ScheduledTask

.Example
    Get-ScheduledTask |Show-ScheduledTask.ps1

    (Returns a readable list of scheduled tasks.)
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
[Parameter(ValueFromPipeline=$true)]
[ValidateScript({$_.CimClass -and $_.CimClass.CimClassName -eq 'MSFT_ScheduledTask'})]
[Microsoft.Management.Infrastructure.CimInstance]$Task
)
Begin
{
    function Format-Action([Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [ValidateScript({$_.CimClass -and $_.CimClass.CimSuperClassName -eq 'MSFT_TaskAction'})]
        [Microsoft.Management.Infrastructure.CimInstance]$Action)
    {Process{
        Import-Variables.ps1 $Action
        switch($Action.CimClass.CimClassName)
        {
            MSFT_TaskExecAction {"$WorkingDirectory> $Execute $Arguments"}
            default {"$($Action.CimClass.CimClassName): $(ConvertTo-Json $Action.CimInstanceProperties -Compress)"}
        }
    }}
    function Format-Trigger([Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        [ValidateScript({$_.CimClass})][Microsoft.Management.Infrastructure.CimInstance]$Trigger)
    {Process{
        Import-Variables.ps1 $Trigger
        $disabled = if(!$Enabled){' [disabled]'}
        switch($Trigger.CimClass.CimClassName)
        {
            MSFT_TaskTimeTrigger {"Once at $(Get-Date $StartBoundary -f 'ddd MMM dd, yyyy HH:mm:ss')$disabled"}
            MSFT_TaskDailyTrigger {"Daily at $(Get-Date $StartBoundary -f HH:mm:ss)$disabled"}
            MSFT_TaskWeeklyTrigger {"Weekly on $(Get-Date $StartBoundary -f 'ddd \a\t HH:mm:ss')$disabled"}
            default {"$($Trigger.CimClass.CimClassName): $(ConvertTo-Json $Trigger -Compress)"}
        }
    }}
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
