<#
.Synopsis
    Combines a filename with a string.

.Description
    Join-FileName appends a string to a filename, including a new extension 
    overwrites the filename's extension.

.Example
    Join-FileName.ps1 activity.log '-20161111'


    activity-20161111.log

.Example
    Join-FileName.ps1 readme.txt .bak


    readme.bak

.Example
    Join-FileName.ps1 C:\temp\activity.log .27.old


    C:\temp\activity.27.old
#>

[CmdletBinding()] Param(
[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][string] $Path,
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
