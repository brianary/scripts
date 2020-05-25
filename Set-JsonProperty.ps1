<#
.Synopsis
	Sets a property of arbitrary depth in a JSON string.

.Parameter PropertyName
	The full path name of the property to set.

	With the default path separator of . for a name of powershell.codeFormatting.preset sets
	{ "powershell": { "codeFormatting": { "preset": "value" } } }
	this can be escaped to powershell\.codeFormatting\.preset to set
	{ "powershell.codeFormatting.preset": "value" }
	Changing the path separator to / for a name of powershell.codeFormatting.preset also sets
	{ "powershell.codeFormatting.preset": "value" }

.Parameter PropertyValue
	The value to set the property to.

.Parameter PathSeparator
	The character to use as a property name path separator (dot by default).

	With the default path separator of . for a name of powershell.codeFormatting.preset sets
	{ "powershell": { "codeFormatting": { "preset": "value" } } }
	this can be escaped to powershell\.codeFormatting\.preset to set
	{ "powershell.codeFormatting.preset": "value" }
	Changing the path separator to / for a name of powershell.codeFormatting.preset also sets
	{ "powershell.codeFormatting.preset": "value" }

.Parameter InputObject
	The JSON string to set the property in.

.Link
	ConvertFrom-Json

.Link
	ConvertTo-Json

.Link
	Add-Member

.Example
	'{a:1}' |Set-JsonProperty.ps1 b.ZZ\.ZZ.thing 7

	{
		"a": 1,
		"b": {
				"ZZ.ZZ": {
					"thing": 7
				}
		}
	}
#>

[CmdletBinding()] Param(
[Alias('Name')][Parameter(Position=0,Mandatory=$true)][string] $PropertyName,
[Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][AllowEmptyCollection()][AllowNull()]
[Alias('Value')][psobject] $PropertyValue,
[Alias('Separator','Delimiter')][char] $PathSeparator = '.',
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $InputObject
)
Begin
{
	$UnescapedPathSeparator = "(?<=(?:\A|[^\\])(?:\\\\)*)$([regex]::Escape($PathSeparator))"
	[string[]] $path = ($PropertyName -split $UnescapedPathSeparator) -replace '(?s)\\(.)','$1'
}
Process
{
	$object = $InputObject |ConvertFrom-Json
	$property = $object
	for($i = 0; $i -lt ($path.Length-1); $i++)
	{
		$nameSegment = $path[$i]
		if(!$property.PSObject.Properties.Match($nameSegment,'NoteProperty').Count)
		{
			$property |Add-Member $nameSegment ([pscustomobject]@{})
		}
		$property = $property.$nameSegment
	}
	$nameSegment = $path[-1]
	if($property.PSObject.Properties.Match($nameSegment,'NoteProperty').Count)
	{
		$property.$nameSegment = $PropertyValue
	}
	else {$property |Add-Member ($path[-1]) $PropertyValue}
	$object |ConvertTo-Json
}
