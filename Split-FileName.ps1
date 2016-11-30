<#
.Synopsis
    Returns the specified part of the filename.

.Description
    Split-FileName returns only the specified part of a filename: 
    either the filename without extension (default) or extension.
    It can also tell whether the filename has an extension.

.Example
    Split-FileName.ps1 readme.txt
    readme

.Example
    Split-FileName.ps1 readme.txt -Extension
    ․txt
    (the leading . is included, but can't be entered as such in this example)

.Example
    Split-FileName.ps1 readme.txt -HasExtension
    True
#>

[CmdletBinding()] Param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $Path,
[switch] $HasExtension,
[switch] $Extension
)
Process
{
	if($HasExtension) { [IO.Path]::HasExtension($Path) }
	elseif($Extension) { [IO.Path]::GetExtension($Path) }
	else { [IO.Path]::GetFileNameWithoutExtension($Path) }
}
