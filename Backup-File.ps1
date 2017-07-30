<#
.Synopsis
    Create a backup as a sibling to a file, with date and time values in the name.

.Parameter Path
    Specifies a path to the items being removed. Wildcards are permitted.
    The parameter name ("-Path") is optional.

.Inputs
    System.String: file path

.Example
    Backup-File.ps1 logfile.log

    Copies logfile.log to logfile-201612311159.log (on that date & time).
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ValueFromRemainingArguments=$true)]
[string]$Path
)
$name = Split-Path $Path -Leaf
$name = "$([IO.Path]::GetFileNameWithoutExtension($name))-$(Get-Date -Format yyyyMMddHHmmss).$([IO.Path]::GetExtension($name))"
Copy-Item $Path (Join-Path (Split-Path $Path) $name)
