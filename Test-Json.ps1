<#
.SYNOPSIS
Determines whether a string is valid JSON.

.PARAMETER InputObject
The string to test.

.INPUTS
System.String value to test for a valid JSON format.

.OUTPUTS
System.Boolean indicating that the string can be parsed as JSON.

.EXAMPLE
Test-Json.ps1 '{"value":6}'

True

.EXAMPLE
Test-Json.ps1 0

True

.EXAMPLE
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
