<#
.Synopsis
	Indicates that a file contains text.

.Parameter Path
	A file to test.

.Outputs
	System.Boolean indicating that the file contains text.

.Link
	Test-FileTypeMagicNumber.ps1

.Example
	Test-TextFile.ps1 README.md

	True

.Example
	Test-TextFile.ps1 avatar.jpg

	False
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[ValidateScript({Test-Path $_ -Type Leaf})][Alias('FullName')][string] $Path
)
Process
{
	return (Test-FileTypeMagicNumber.ps1 text $Path)
}
