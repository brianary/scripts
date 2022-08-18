<#
.SYNOPSIS
Sets a property of arbitrary depth in a JSON string.

.INPUTS
System.String containing JSON.

.OUTPUTS
System.String containing updated JSON.

.LINK
ConvertFrom-Json

.LINK
ConvertTo-Json

.LINK
Add-Member

.EXAMPLE
'{a:1}' |Set-JsonProperty.ps1 b.ZZ\.ZZ.thing 7

{
  "a": 1,
  "b": {
    "ZZ.ZZ": {
      "thing": 7
    }
  }
}

.EXAMPLE
Set-JsonProperty.ps1 powershell.codeFormatting.preset Allman -PathSeparator ~ -Path ./.vscode/settings.json

Sets "powershell.codeFormatting.preset": "Allman" within the ./.vscode/settings.json file.
#>

#Requires -Version 7
[CmdletBinding()][OutputType([string])] Param(
<#
The full path name of the property to set.

With the default path separator of . for a name of powershell.codeFormatting.preset sets
{ "powershell": { "codeFormatting": { "preset": "value" } } }
this can be escaped to powershell\.codeFormatting\.preset to set
{ "powershell.codeFormatting.preset": "value" }
Changing the path separator to / for a name of powershell.codeFormatting.preset also sets
{ "powershell.codeFormatting.preset": "value" }
#>
[Alias('Name')][Parameter(Position=0,Mandatory=$true)][string] $PropertyName,
# The value to set the property to.
[Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][AllowEmptyCollection()][AllowNull()]
[Alias('Value')][psobject] $PropertyValue,
<#
The character to use as a property name path separator (dot by default).

With the default path separator of . for a name of powershell.codeFormatting.preset sets
{ "powershell": { "codeFormatting": { "preset": "value" } } }
this can be escaped to powershell\.codeFormatting\.preset to set
{ "powershell.codeFormatting.preset": "value" }
Changing the path separator to / for a name of powershell.codeFormatting.preset also sets
{ "powershell.codeFormatting.preset": "value" }
#>
[Alias('Separator','Delimiter')][char] $PathSeparator = '.',
# Indicates that overwriting values should generate a warning.
[switch] $WarnOverwrite,
# The JSON string to set the property in.
[Parameter(ParameterSetName='InputObject',Mandatory=$true,ValueFromPipeline=$true)][string] $InputObject,
# A JSON file to update.
[Parameter(ParameterSetName='Path',Mandatory=$true)][string] $Path
)
Begin
{
	$UnescapedPathSeparator = "(?<=(?:\A|[^\\])(?:\\\\)*)$([regex]::Escape($PathSeparator))"
	[string[]] $jsonpath = ($PropertyName -split $UnescapedPathSeparator) -replace '(?s)\\(.)','$1'
}
Process
{
	$object = ($Path ? Get-Content $Path -Raw : $InputObject) |ConvertFrom-Json
	$property = $object
	for($i = 0; $i -lt ($jsonpath.Length-1); $i++)
	{
		$nameSegment = $jsonpath[$i]
		if(!$property.PSObject.Properties.Match($nameSegment,'NoteProperty').Count)
		{
			$property |Add-Member $nameSegment ([pscustomobject]@{})
		}
		$property = $property.$nameSegment
	}
	$nameSegment = $jsonpath[-1]
	if($property.PSObject.Properties.Match($nameSegment,'NoteProperty').Count)
	{
		if($WarnOverwrite) {Write-Warning "Property $PropertyName overwriting '$($property.$nameSegment)'."}
		$property.$nameSegment = $PropertyValue
	}
	else {$property |Add-Member ($jsonpath[-1]) $PropertyValue}
	$value = $object |ConvertTo-Json -Depth 100
	if($Path) {$value |Out-File $Path utf8NoBOM}
	else {return $value}
}
