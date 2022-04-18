<#
.SYNOPSIS
Exports the local list of Scheduled Tasks into a single XML file.

.LINK
https://msdn.microsoft.com/library/windows/desktop/bb736357.aspx

.EXAMPLE
Backup-SchTasks.ps1

(Backs up Windows Scheduled Tasks to tasks.xml.)
#>

[CmdletBinding()][OutputType([void])] Param( [Parameter(Position=0)][string]$Path = 'tasks.xml' )
schtasks /query /xml |? {$_ -notlike '<?xml *?>'} |Out-File $Path -Encoding utf8 -Width ([int]::MaxValue)
