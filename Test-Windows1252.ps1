<#
.SYNOPSIS
Determines whether a file contains Windows-1252 bytes that are invalid UTF-8 bytes.

.INPUTS
System.String containing the path to a file to test.

.FUNCTIONALITY
Data formats

.LINK
https://en.wikipedia.org/wiki/Windows-1252#Character_set

.EXAMPLE
Test-Windows1252.ps1 readme.md

False
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The path to a file to test.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path
)
Process
{
	$readbytes =
		if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=$true}}
		else {@{Encoding='Byte'}}
	if($Path) {[byte[]]$bytes = Get-Content $Path @readbytes -Raw}
	foreach($c in 0x0152,0x0153,0x0160,0x0161,0x0178,0x017D,0x017E,0x0192,0x02C6,0x02DC,0x2013,0x2014,0x2018,0x2019,
		0x201A,0x201C,0x201D,0x201E,0x2020,0x2021,0x2022,0x2026,0x2030,0x2039,0x203A,0x20AC,0x2122)
	{
		if($bytes.Contains($c)) {return $true}
	}
	return $false
}
