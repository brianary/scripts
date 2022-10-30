<#
.SYNOPSIS
Exports the local list of Scheduled Tasks into a single XML file.

.LINK
https://msdn.microsoft.com/library/windows/desktop/bb736357.aspx

.EXAMPLE
Backup-SchTasks.ps1

Backs up Windows Scheduled Tasks to tasks.xml.

.EXAMPLE
Backup-SchTasks.ps1 tasks-backup.xml -Stylesheet tasks.css

Saves scheduled tasks to tasks-backup.xml using tasks.css as a viewing stylesheet.
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
	"<?xml-stylesheet href=`"$Stylesheet`" type=`"text/$([io.path]::GetExtension($Stylesheet).Trim('.'))`"?>" |
		Out-File $Path -Encoding utf8 -Append
}
schtasks /query /xml |
	Where-Object {$_ -notlike '<?xml *?>'} |
	Out-File $Path -Encoding utf8 -Width ([int]::MaxValue) -Append
