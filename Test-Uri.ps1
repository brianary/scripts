<#
.SYNOPSIS
Determines whether a string is a valid URI.

.PARAMETER InputObject
The string to test.

.PARAMETER UriKind
What kind of URI to test for: Absolute, Relative, or RelativeOrAbsolute.

.INPUTS
System.String value to test for a valid URI format.

.OUTPUTS
System.Boolean indicating that the string can be parsed as a URI.

.EXAMPLE
Test-Uri.ps1 http://example.org

True

.EXAMPLE
Test-Uri.ps1 0

False
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][AllowEmptyString()][AllowNull()][string] $InputObject,
[Parameter(Position=1)][UriKind] $UriKind = 'Absolute'
)
Process
{
    if(!$InputObject) {return $false}
    return [uri]::TryCreate($InputObject,$UriKind,[ref]$null)
}
