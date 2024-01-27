<#
.SYNOPSIS
Exports a portion of a JSON document, recursively importing references.

.INPUTS
System.String containing JSON, or
System.Collections.Hashtable parsed from JSON, or
System.Management.Automation.PSObject parsed from JSON.

.OUTPUTS
System.String containing the extracted JSON.

.FUNCTIONALITY
Json

.LINK
http://jsonref.org/

.LINK
https://www.rfc-editor.org/rfc/rfc6901

.EXAMPLE
'{d:{a:{b:1,c:{"$ref":"#/d/two"}},two:2}}' |Export-Json.ps1 /d/a

{
  "b": 1,
  "c": 2
}

.EXAMPLE
'{d:{a:{b:1,c:{"$ref":"#/d/c"}},c:{d:{"$ref":"#/d/two"}},two:2}}' |Export-Json.ps1 /d/a

{
  "b": 1,
  "c": {
    "d": 2
  }
}
#>

#Requires -Version 7
[CmdletBinding()] Param(
<#
The full path name of the property to get, as a JSON Pointer, which separates each nested
element name with a /, and literal / is escaped as ~1, and literal ~ is escaped as ~0.
#>
[Parameter(Position=0)][Alias('Name')][AllowEmptyString()][ValidatePattern('\A(?:|/(?:[^~]|~0|~1)*)\z')]
[string] $PropertyName = '',
# The JSON (string or parsed object/hashtable) to get the value from.
[Parameter(ParameterSetName='InputObject',ValueFromPipeline=$true)] $InputObject
)

function Get-Reference
{
	[CmdletBinding()] Param(
	[uri] $ReferenceUri,
	$Root
	)
	if($ReferenceUri.OriginalString -like '#*')
	{
		return $Root |
			Select-Json.ps1 ($ReferenceUri.OriginalString -replace '\A#') |
			Import-Reference -Root $Root
	}
	return Invoke-RestMethod $ReferenceUri |
		Select-Json.ps1 ($ReferenceUri.Fragment -replace '\A#') |
		Import-Reference -Root $Root
}

filter Import-Reference
{
	[CmdletBinding()] Param(
	$Root,
	[Parameter(ValueFromPipeline=$true)] $InputObject
	)
	if($null -eq $InputObject -or $InputObject -is [bool] -or $InputObject -is [long] -or
		$InputObject -is [double] -or $InputObject -is [string]) {return $InputObject}
	if(($InputObject |ConvertTo-Json -Depth 100) -notlike '*"$ref":*') {return $InputObject}
	if($InputObject -is [Collections.IList]) {return ,@($InputObject |Import-References)}
	if($InputObject -is [Collections.IDictionary])
	{
		if($InputObject.ContainsKey('$ref'))
		{
			return Get-Reference -ReferenceUri $InputObject['$ref'] -Root $Root
		}
		foreach($name in $InputObject.Keys)
		{
			$InputObject[$name] = Import-Reference -Root $Root -InputObject $InputObject[$name]
		}
		return $InputObject
	}
	if($InputObject.PSObject.Properties.Match('$ref').Count)
	{
		return Get-Reference -ReferenceUri ($InputObject.'$ref') -Root $Root
	}
	foreach($property in $InputObject.PSObject.Properties)
	{
		$name = $property.Name
		$InputObject.$name = Import-Reference -Root $Root -InputObject ($InputObject.$name)
	}
	return $InputObject
}

$root = $InputObject -is [string] ? ($InputObject |ConvertFrom-Json) : $InputObject
$selection = $root |Select-Json.ps1 $PropertyName
return $selection |Import-Reference -Root $root |ConvertTo-Json -Depth 100
