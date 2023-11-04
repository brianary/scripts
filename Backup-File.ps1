<#
.SYNOPSIS
Create a backup as a sibling to a file, with date and time values in the name.

.DESCRIPTION
This provides a quick way to back up a file, usually before making changes that may need
to be reverted.

.INPUTS
System.String, a file path to back up.

.FUNCTIONALITY
Files

.LINK
Copy-Item

.LINK
Split-Path

.LINK
Join-Path

.LINK
Resolve-Path

.LINK
Get-Date

.EXAMPLE
Backup-File.ps1 logfile.log

Copies logfile.log to logfile-201612311159.log (on that date & time).
#>

#Requires -Version 7
[CmdletBinding()][OutputType([void])] Param(
<#
Specifies a path to the items being removed. Wildcards are permitted.
The parameter name ("-Path") is optional.
#>
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[string]$Path
)
Process
{
	$name = "$(Split-Path $Path -LeafBase)-$(Get-Date -Format yyyyMMddHHmmss)$(Split-Path $Path -Extension)"
	Copy-Item $Path (Resolve-Path $Path |Split-Path |Join-Path -ChildPath $name)
}
