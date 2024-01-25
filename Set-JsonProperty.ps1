<#
.SYNOPSIS
Sets a property of arbitrary depth in a JSON string.

.INPUTS
System.String containing JSON.

.OUTPUTS
System.String containing updated JSON.

.FUNCTIONALITY
Json

.LINK
https://datatracker.ietf.org/doc/html/draft-ietf-appsawg-json-pointer-04

.LINK
ConvertFrom-Json

.LINK
ConvertTo-Json

.LINK
Add-Member

.EXAMPLE
'{a:1}' |Set-JsonProperty.ps1 /b/ZZ~1ZZ/thing 7

{
  "a": 1,
  "b": {
    "ZZ/ZZ": {
      "thing": 7
    }
  }
}

.EXAMPLE
Set-JsonProperty.ps1 /powershell.codeFormatting.preset Allman -Path ./.vscode/settings.json

Sets "powershell.codeFormatting.preset": "Allman" within the ./.vscode/settings.json file.
#>

#Requires -Version 7
[CmdletBinding()][OutputType([string])] Param(
<#
The full path name of the property to set, as a JSON Pointer, which separates each nested
element name with a /, and literal / is escaped as ~1, and literal ~ is escaped as ~0.
#>
[Alias('Name')][Parameter(Position=0,Mandatory=$true)][string] $PropertyName,
# The value to set the property to.
[Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][AllowEmptyCollection()][AllowNull()]
[Alias('Value')][psobject] $PropertyValue,
# Indicates that overwriting values should generate a warning.
[switch] $WarnOverwrite,
# The JSON string to set the property in.
[Parameter(ParameterSetName='InputObject',Mandatory=$true,ValueFromPipeline=$true)][string] $InputObject,
# A JSON file to update.
[Parameter(ParameterSetName='Path',Mandatory=$true)][string] $Path
)
Begin
{
	[string[]] $jsonpath = switch($PropertyName)
	{
		'' {@()}
		'/' {@('')}
		default {$_ -replace '\A/' -split '/' -replace '~1','/' -replace '~0','~'}
	}
}
Process
{
	$object = ($Path ? (Get-Content $Path -Raw) : $InputObject) |ConvertFrom-Json -AsHashtable
	$property = $object
	for($i = 0; $i -lt ($jsonpath.Length-1); $i++)
	{
		$nameSegment = $jsonpath[$i]
		if(!$property.ContainsKey($nameSegment))
		{
			$property[$nameSegment] = @{}
		}
		$property = $property.$nameSegment
	}
	$nameSegment = $jsonpath[-1]
	if($property.ContainsKey($nameSegment))
	{
		if($WarnOverwrite) {Write-Warning "Property $PropertyName overwriting '$($property.$nameSegment)'."}
		$property[$nameSegment] = $PropertyValue
	}
	else {$property[$jsonpath[-1]] = $PropertyValue}
	$value = $object |ConvertTo-Json -Depth 100
	if($Path) {$value |Out-File $Path utf8NoBOM}
	else {return $value}
}
