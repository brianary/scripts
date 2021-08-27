<#
.Synopsis
	Returns true if a file ends with a newline as required by the POSIX standard.

.Parameter Path
    The file to test.

.Inputs
	System.IO.FileInfo file or similar object to test for UTF-8 validity.

.Outputs
	System.Boolean indicating whether the file ends with a newline.

.Link
	Test-MagicNumber.ps1

.Example
	Test-FinalNewline.ps1 README.md

	True
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path
)
Process
{
	Test-MagicNumber.ps1 0x0A $Path -Offset -1
}
