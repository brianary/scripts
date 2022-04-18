<#
.SYNOPSIS
Returns the specified part of the filename.

.DESCRIPTION
Split-FileName returns only the specified part of a filename: 
either the filename without extension (default) or extension.
It can also tell whether the filename has an extension.

.INPUTS
System.String file path to parse.

.OUTPUTS
System.String containing the base file name (or extension),
or System.Boolean if the -HasAttribute switch is present.

.EXAMPLE
Split-FileName.ps1 readme.txt

readme

.EXAMPLE
Split-FileName.ps1 readme.txt -Extension

․txt
(the leading . is included, but can't be entered as such in this example)

.EXAMPLE
Split-FileName.ps1 readme.txt -HasExtension

True
#>

[CmdletBinding(DefaultParameterSetName='__AllParameterSets')][OutputType([string])][OutputType([bool],ParameterSetName='HasExtension')] Param(
# A file path to extract a part of; the base name without extension by default.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string] $Path,
<#
Indicates that the path should be checked for the presence of an extension,
returning a boolean value.
#>
[Parameter(ParameterSetName='HasExtension')][switch] $HasExtension,
# Indicates the path's extension should be returned.
[Parameter(ParameterSetName='Extension')][switch] $Extension
)
Process
{
	if($HasExtension) { [IO.Path]::HasExtension($Path) }
	elseif($Extension) { [IO.Path]::GetExtension($Path) }
	else { [IO.Path]::GetFileNameWithoutExtension($Path) }
}
