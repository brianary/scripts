<#
.Synopsis
    Returns the specified part of the filename.

.Description
    Split-FileName returns only the specified part of a filename: 
    either the filename without extension (default) or extension.
    It can also tell whether the filename has an extension.

.Parameter Path
    A file path to extract a part of; the base name without extension by default.

.Parameter HasExtension
    Indicates that the path should be checked for the presence of an extension,
    returning a boolean value.

.Parameter Extension
    Indicates the path's extension should be returned.

.Inputs
    System.String file path to parse.

.Outputs
    System.String containing the base file name (or extension),
    or System.Boolean if the -HasAttribute switch is present.

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

[CmdletBinding()][OutputType([string])][OutputType([bool],ParameterSetName='HasExtension')] Param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $Path,
[Parameter(ParameterSetName='HasExtension')][switch] $HasExtension,
[Parameter(ParameterSetName='Extension')][switch] $Extension
)
Process
{
	if($HasExtension) { [IO.Path]::HasExtension($Path) }
	elseif($Extension) { [IO.Path]::GetExtension($Path) }
	else { [IO.Path]::GetFileNameWithoutExtension($Path) }
}
