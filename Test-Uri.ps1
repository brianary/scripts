<#
.Synopsis
	Determines whether a string is a valid URI.

.Parameter InputObject
    The string to test.

.Parameter UriKind
    What kind of URI to test for: Absolute, Relative, or RelativeOrAbsolute.

.Inputs
	System.String value to test for a valid URI format.

.Outputs
	System.Boolean indicating that the string can be parsed as a URI.

.Example
	Test-Uri.ps1 http://example.org

    True

.Example
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
