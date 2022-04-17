<#
.SYNOPSIS
Indicates that a file contains text.

.PARAMETER Path
A file to test.

.OUTPUTS
System.Boolean indicating that the file contains text.

.LINK
Test-FileTypeMagicNumber.ps1

.EXAMPLE
Test-TextFile.ps1 README.md

True

.EXAMPLE
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
