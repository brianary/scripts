<#
.SYNOPSIS
Returns true if a file starts with a utf-8 signature (BOM).

.INPUTS
System.IO.FileInfo file or similar object to test for UTF-8 validity.

.OUTPUTS
System.Boolean indicating whether the file starts with a utf-8 signature (BOM).

.LINK
Test-FileTypeMagicNumber.ps1

.EXAMPLE
Test-Utf8Signature.ps1 README.md

False
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
# The file to test.
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path
)
Process
{
	Test-FileTypeMagicNumber.ps1 utf8 $Path
}

