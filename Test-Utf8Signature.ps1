<#
.Synopsis
	Returns true if a file starts with a utf-8 signature (BOM).

.Parameter Path
    The file to test.

.Inputs
	System.IO.FileInfo file or similar object to test for UTF-8 validity.

.Outputs
	System.Boolean indicating whether the file starts with a utf-8 signature (BOM).

.Link
	Test-FileTypeMagicNumber.ps1

.Example
	Test-Utf8Signature.ps1 README.md

	False
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path
)
Process
{
	Test-FileTypeMagicNumber.ps1 utf8 $Path
}
