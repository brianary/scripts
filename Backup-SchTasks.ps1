<#
.SYNOPSIS
Exports the local list of Scheduled Tasks into a single XML file.

.DESCRIPTION
This backs up the Scheduled Tasks set up on the system to a file which can be restored
again later. This can be useful before migrating a server/workstation, or before making
significant changes to some tasks that may need to be reverted.

.NOTES
Notice that the root Tasks element does not have an XML namespace, but the individual
Task child element elements are in the http://schemas.microsoft.com/windows/2004/02/mit/task
namespace.

.FUNCTIONALITY
Scheduled Tasks

.LINK
https://msdn.microsoft.com/library/windows/desktop/bb736357.aspx

.EXAMPLE
Backup-SchTasks.ps1

Backs up Windows Scheduled Tasks to tasks.xml.

.EXAMPLE
Backup-SchTasks.ps1 tasks-backup.xml -Stylesheet tasks.css

Saves scheduled tasks to tasks-backup.xml using tasks.css as a display stylesheet.
#>

[CmdletBinding()][OutputType([void])] Param(
# The XML file to backup the list of scheduled tasks to.
[Parameter(Position=0)][string]$Path = 'tasks.xml',
# A CSS or XSLT stylesheet to use when viewing the scheduled tasks XML.
[string] $Stylesheet
)

'<?xml version="1.0"?>' |Out-File $Path -Encoding utf8
if($Stylesheet)
{
	"<?xml-stylesheet href=`"$Stylesheet`" type=`"text/$((Split-Path $Stylesheet -Extension).Trim('.'))`"?>" |
		Out-File $Path -Encoding utf8 -Append
}
schtasks /query /xml |
	Where-Object {$_ -notlike '<?xml *?>'} |
	Out-File $Path -Encoding utf8 -Width ([int]::MaxValue) -Append
