<#
.Synopsis
	Indicates that a file contains binary data.

.Parameter Path
	A file to test.

.Outputs
	System.Boolean indicating that the file contains binary data.

.Link
	Test-TextFile.ps1

.Example
	Test-BinaryFile.ps1 avatar.jpg

	True

.Example
	Test-BinaryFile.ps1 README.md

	False
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[ValidateScript({Test-Path $_ -Type Leaf})][Alias('FullName')][string] $Path
)
Process
{
	return !(Test-TextFile.ps1 $Path)
}
