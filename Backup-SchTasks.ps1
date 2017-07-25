<#
.Synopsis
    Exports the local list of Scheduled Tasks into a single XML file.

.Parameter Path
    The name of the XML file to export to.

.Link
    https://msdn.microsoft.com/library/windows/desktop/bb736357.aspx

.Example
    Backup-SchTasks.ps1

    (Backs up Windows Scheduled Tasks to tasks.xml.)
#>

[CmdletBinding()] Param( [Parameter(Position=0)][string]$Path = 'tasks.xml' )
schtasks /query /xml |? {$_ -notlike '<?xml *?>'} |Out-File $Path -Encoding utf8
