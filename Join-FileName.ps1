<#
.SYNOPSIS
Combines a filename with a string.

.DESCRIPTION
Join-FileName appends a string to a filename, including a new extension
overwrites the filename's extension.

.INPUTS
System.String file path.

.OUTPUTS
System.String file path with appended text.

.FUNCTIONALITY
Files

.EXAMPLE
Join-FileName.ps1 activity.log '-20161111'

activity-20161111.log

.EXAMPLE
Join-FileName.ps1 readme.txt .bak

readme.bak

.EXAMPLE
Join-FileName.ps1 C:\temp\activity.log .27.old

C:\temp\activity.27.old
#>

[CmdletBinding()][OutputType([string])] Param(
# The path to a file.
[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][string] $Path,
# Text to append to the filename, either before the extension or including one.
[Parameter(Mandatory=$true,Position=1)][Alias('Extension')][string] $AppendText
)
Process
{
	if($AppendText -like '.*') { [IO.Path]::ChangeExtension($Path,$AppendText) }
	else
	{
		$name = [IO.Path]::GetFileNameWithoutExtension($Path) + $AppendText;
		if($AppendText -notlike '*.*'){$name+=[IO.Path]::GetExtension($Path)}
		if(Split-Path $Path) { Join-Path (Split-Path $Path) $name }
		else { $name }
	}
}

