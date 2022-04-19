<#
.SYNOPSIS
Indicates that a file contains binary data.

.OUTPUTS
System.Boolean indicating that the file contains binary data.

.LINK
Test-TextFile.ps1

.EXAMPLE
Test-BinaryFile.ps1 avatar.jpg

True

.EXAMPLE
Test-BinaryFile.ps1 README.md

False
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
# A file to test.
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[ValidateScript({Test-Path $_ -Type Leaf})][Alias('FullName')][string] $Path
)
Process
{
	return !(Test-TextFile.ps1 $Path)
}
