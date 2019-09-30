<#
.Synopsis
	Determines whether a string is valid JSON.

.Parameter InputObject
    The string to test.

.Inputs
	System.String value to test for a valid JSON format.

.Outputs
	System.Boolean indicating that the string can be parsed as JSON.

.Example
	Test-Json.ps1 '{"value":6}'

    True

.Example
    Test-Json.ps1 0

    True

.Example
    Test-Json.ps1 '{'

    False
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][AllowEmptyString()][AllowNull()][string] $InputObject
)
Process
{
    if(!$InputObject) {return $false}
    try {ConvertFrom-Json $InputObject -ErrorAction Stop |Out-Null; return $true}
    catch {return $false}
}
