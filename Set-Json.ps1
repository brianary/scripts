<#
.SYNOPSIS
Sets a property in a JSON string or file.

.INPUTS
System.String containing JSON.

.OUTPUTS
System.String containing updated JSON (unless a file is specified, which is updated).

.FUNCTIONALITY
Json

.LINK
https://www.rfc-editor.org/rfc/rfc6901

.LINK
ConvertFrom-Json

.LINK
ConvertTo-Json

.LINK
Add-Member

.EXAMPLE
'0' |Set-Json.ps1 -PropertyValue $true

true

.EXAMPLE
'{}' |Set-Json.ps1 / $false

{
  "": false
}

.EXAMPLE
'{}' |Set-Json.ps1 /~1/~0 3.14

{
  "/": {
    "~": 3.14
  }
}

.EXAMPLE
'[1, 2, 3]' |Set-Json.ps1 /1 0

[
  1,
  0,
  3
]

.EXAMPLE
'[1, 2]' |Set-Json.ps1 /- 3

[
  1,
  2,
  3
]

.EXAMPLE
'{a:{b:[1,2]}}' |Set-Json.ps1 /a/b/- 3

{
  "a": {
    "b": [
      1,
      2,
      3
    ]
  }
}

.EXAMPLE
'{a:1}' |Set-Json.ps1 /b/ZZ~1ZZ/AD~0BC 7

{
  "a": 1,
  "b": {
    "ZZ/ZZ": {
      "AD~BC": 7
    }
  }
}

.EXAMPLE
Set-Json.ps1 /powershell.codeFormatting.preset Allman -Path ./.vscode/settings.json

Sets "powershell.codeFormatting.preset": "Allman" within the ./.vscode/settings.json file.
#>

#Requires -Version 7
[CmdletBinding()][OutputType([string])] Param(
<#
The full path name of the property to set, as a JSON Pointer, which separates each nested
element name with a /, and literal / is escaped as ~1, and literal ~ is escaped as ~0.
#>
[Parameter(Position=0)][Alias('Name')][AllowEmptyString()][ValidatePattern('\A(?:|/(?:[^~]|~0|~1)*)\z')]
[string] $JsonPointer = '',
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
	[string[]] $jsonpath = switch($JsonPointer) { '' {,@()}
		default {,@($_ -replace '\A/' -split '/' -replace '~1','/' -replace '~0','~')} }
}
Process
{
	if(!$jsonpath.Length)
	{
		if($Path) {$PropertyValue |ConvertTo-Json -Depth 100 |Out-File $Path utf8NoBOM; return}
		else {return $PropertyValue |ConvertTo-Json -Depth 100}
	}
	$object = ($Path ? (Get-Content $Path -Raw) : $InputObject) |ConvertFrom-Json -AsHashtable
	if($null -eq $object) {return}
	$property,$parent = $object,$null
	for($i = 0; $i -lt ($jsonpath.Length-1); $i++)
	{
		$segment = $jsonpath[$i]
		if($property -is [array])
		{
			if($i -eq 0 -and $segment -eq '-') {$property = @{}; $object += $property; $segment = $object.Count}
			if(![int]::TryParse($segment,[ref]$segment)) {Stop-ThrowError.ps1 "Could not use array index $segment" -Argument JsonPointer}
			elseif($property.Count -le $segment) {$property = @{}; $object += $property; $segment = $object.Count}
			else {$property,$parent = $property[$segment],$property}
		}
		else
		{
			if(!$property.ContainsKey($segment)) {$property[$segment] = @{}}
			$property,$parent = $property.$segment,$property
		}
		if($property -is [array] -and $i -lt ($jsonpath.Length-2) -and $jsonpath[$i+1] -eq '-')
		{ # RFC6091 uses '-' to append to an array
			$property += @{}
			$jsonpath[$i+1] = $property.Count
			$parent.$segment = $property
		}
	}
	$segment = $jsonpath[-1]
	if($property -is [array])
	{
		if($segment -eq '-') {if($jsonpath.Length -eq 1) {$object += $PropertyValue} else {$parent.$($jsonpath[-2]) += $PropertyValue}}
		elseif(![int]::TryParse($segment,[ref]$segment)) {Stop-ThrowError.ps1 "Could not use array index $segment" -Argument JsonPointer}
		elseif($property.Count -le $segment) {if($jsonpath.Length -eq 1) {$object += $PropertyValue} else {$parent.$($jsonpath[-2]) += $PropertyValue}}
		else {$property[$segment] = $PropertyValue}
	}
	else
	{
		if($property.ContainsKey($segment) -and $WarnOverwrite) {Write-Warning "Property $JsonPointer overwriting '$($property.$segment)'."}
		$property[$segment] = $PropertyValue
	}
	$value = $object |ConvertTo-Json -Depth 100
	if($Path) {$value |Out-File $Path utf8NoBOM}
	else {return $value}
}
