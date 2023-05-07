<#
.SYNOPSIS
Returns true if a file ends with a newline as required by the POSIX standard.

.INPUTS
System.IO.FileInfo file or similar object to test for UTF-8 validity.

.OUTPUTS
System.Boolean indicating whether the file ends with a newline.

.LINK
Test-MagicNumber.ps1

.EXAMPLE
Test-FinalNewline.ps1 README.md

True
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
# The file to test.
[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)]
[Alias('FullName')][string] $Path
)
Process
{
	Test-MagicNumber.ps1 0x0A $Path -Offset -1
}

