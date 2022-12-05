<#
.SYNOPSIS
Determines whether a string is a valid URI.

.INPUTS
System.String value to test for a valid URI format.

.OUTPUTS
System.Boolean indicating that the string can be parsed as a URI.

.FUNCTIONALITY
Data formats

.EXAMPLE
Test-Uri.ps1 http://example.org

True

.EXAMPLE
Test-Uri.ps1 0

False
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
# The string to test.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][AllowEmptyString()][AllowNull()][string] $InputObject,
# What kind of URI to test for: Absolute, Relative, or RelativeOrAbsolute.
[Parameter(Position=1)][UriKind] $UriKind = 'Absolute'
)
Process
{
    if(!$InputObject) {return $false}
    return [uri]::TryCreate($InputObject,$UriKind,[ref]$null)
}
