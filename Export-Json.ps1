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

.LINK
Select-Json.ps1

.EXAMPLE
'{d:{a:{b:1,c:{"$ref":"#/d/two"}},two:2}}' |Export-Json.ps1 /d/a

{
  "b": 1,
  "c": 2
}

.EXAMPLE
'{d:{a:{b:1,c:{"$ref":"#/d/c"}},c:{d:{"$ref":"#/d/two"}},two:2}}' |Export-Json.ps1 /d/a -Compress

{"b":1,"c":{"d":2}}
#>

#Requires -Version 7
[CmdletBinding()][OutputType([string])] Param(
<#
The full path name of the property to get, as a JSON Pointer, modified to support wildcards:
~0 = ~  ~1 = /  ~2 = ?  ~3 = *  ~4 = [
#>
[Parameter(Position=0)][Alias('Name')][AllowEmptyString()][ValidatePattern('\A(?:|/(?:[^~]|~[0-4])*)\z')]
[string] $JsonPointer = '',
# The JSON (string or parsed object/hashtable) to get the value from.
[Parameter(ParameterSetName='InputObject',ValueFromPipeline=$true)] $InputObject,
# A JSON file to update.
[Parameter(ParameterSetName='Path',Mandatory=$true)][string] $Path,
# Omits white space and indented formatting in the output string.
[switch] $Compress
)

function Get-Reference
{
	[CmdletBinding()] Param([uri] $ReferenceUri, $Root)
	$source,$pointer = switch($ReferenceUri)
	{
		{$_.OriginalString -like '#*'} {$Root,($_.OriginalString -replace '\A#')}
		{$_.IsFile} {(Get-Content $_.LocalPath -Raw |ConvertFrom-Json -AsHashtable),($_.Fragment -replace '\A*')}
		default {(Invoke-RestMethod $ReferenceUri),($_.Fragment -replace '\A#')}
	}
	return $source |Select-Json.ps1 $pointer |Import-Reference -Root $source
}

filter Import-Reference
{
	[CmdletBinding()] Param($Root, [Parameter(ValueFromPipeline=$true)] $InputObject)
	if($null -eq $InputObject -or $InputObject -is [bool] -or $InputObject -is [long] -or
		$InputObject -is [double] -or $InputObject -is [string]) {return $InputObject}
	if(($InputObject |ConvertTo-Json -Compress -Depth 100) -notlike '*"$ref":*') {return $InputObject}
	if($InputObject -is [Collections.IList]) {return ,@($InputObject |Import-Reference -Root $Root)}
	if($InputObject -is [Collections.IDictionary])
	{
		if($InputObject.ContainsKey('$ref'))
		{
			return Get-Reference -ReferenceUri $InputObject['$ref'] -Root $Root
		}
		foreach($name in @($InputObject.Keys))
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

if($Path) {$InputObject = Get-Content $Path -Raw}
$root = $InputObject -is [string] ? ($InputObject |ConvertFrom-Json) : $InputObject
$selection = $root |Select-Json.ps1 $JsonPointer
return $selection |Import-Reference -Root $root |ConvertTo-Json -Depth 100 -Compress:$Compress
