<#
.SYNOPSIS
Create a backup as a sibling to a file, with date and time values in the name.

.INPUTS
System.String, a file path to back up.

.FUNCTIONALITY
Files

.EXAMPLE
Backup-File.ps1 logfile.log

Copies logfile.log to logfile-201612311159.log (on that date & time).
#>

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
	$name = Split-Path $Path -Leaf
	$name = "$([IO.Path]::GetFileNameWithoutExtension($name))-$(Get-Date -Format yyyyMMddHHmmss)$([IO.Path]::GetExtension($name))"
	Copy-Item $Path (Resolve-Path $Path |Split-Path |Join-Path -ChildPath $name)
}
