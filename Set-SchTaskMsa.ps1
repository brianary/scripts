<#
.SYNOPSIS
Sets a Scheduled Task's runtime user as the given gMSA/MSA.

.FUNCTIONALITY
Scheduled Tasks

.INPUTS
An object with a TaskName string property.

.LINK
https://learn.microsoft.com/windows-server/identity/ad-ds/manage/group-managed-service-accounts/group-managed-service-accounts/group-managed-service-accounts-overview

.LINK
Set-ScheduledTask

.LINK
New-ScheduledTaskPrincipal

.EXAMPLE
Set-SchTaskMsa.ps1 'Backup VSCode settings' automation

Sets the tasks running user to the "automation" managed service account.
#>

#Requires -Version 7
#Requires -Modules ScheduledTasks
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $TaskName,
[Parameter(Position=1,Mandatory=$true)][Alias('MSA','gMSA','UserId')][string] $ServiceAccount,
[switch] $HighestRunLevel
)
Process
{
    Set-ScheduledTask -TaskName $TaskName -Principal (New-ScheduledTaskPrincipal -UserID $ServiceAccount `
        -LogonType Password -RunLevel:($HighestRunLevel ? 'Highest' : 'Normal'))
}
