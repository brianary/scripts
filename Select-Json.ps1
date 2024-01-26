<#
.SYNOPSIS
Returns a value from a JSON string or file.

.INPUTS
System.String containing JSON, or
System.Collections.Hashtable parsed from JSON, or
System.Management.Automation.PSObject parsed from JSON.

.OUTPUTS
System.Boolean, System.Int64, System.Double, System.String,
System.Management.Automation.PSObject, or
System.Management.Automation.OrderedHashtable (or null) selected from JSON.

.FUNCTIONALITY
Json

.LINK
https://datatracker.ietf.org/doc/html/draft-ietf-appsawg-json-pointer-04

.LINK
ConvertFrom-Json

.EXAMPLE
'true' |Select-Json.ps1  # default selection is entire parsed JSON document

True

.EXAMPLE
'{"":3.14}' |Select-Json.ps1 /

3.14

.EXAMPLE
'{a:1}' |Select-Json.ps1 /a

1

.EXAMPLE
'{a:1}' |Select-Json.ps1 /b |Measure-Object |Select-Object -ExpandProperty Count  # nothing returned

0

.EXAMPLE
Select-Json.ps1 /powershell.codeFormatting.preset -Path ./.vscode/settings.json

Allman

.EXAMPLE
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Select-Json.ps1 /b/ZZ~1ZZ/AD~0BC

7

.EXAMPLE
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Select-Json.ps1 /b/ZZ~1ZZ

Name  Value
----  -----
AD~BC 7

.EXAMPLE
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |ConvertFrom-Json |Select-Json.ps1 /b/ZZ~1ZZ

AD~BC
-----
    7

.EXAMPLE
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Select-Json.ps1 /b/ZZ~1ZZ |ConvertTo-Json -Compress

{"AD~BC":7}
#>

#Requires -Version 7
[CmdletBinding()][OutputType([bool],[long],[double],[string],[Management.Automation.OrderedHashtable])] Param(
<#
The full path name of the property to get, as a JSON Pointer, which separates each nested
element name with a /, and literal / is escaped as ~1, and literal ~ is escaped as ~0.
#>
[Parameter(Position=0)][Alias('Name')][AllowEmptyString()][ValidatePattern('\A(?:|/(?:[^~]|~0|~1)*)\z')]
[string] $PropertyName = '',
# The JSON (string or parsed object/hashtable) to get the value from.
[Parameter(ParameterSetName='InputObject',ValueFromPipeline=$true)] $InputObject,
# A JSON file to update.
[Parameter(ParameterSetName='Path',Mandatory=$true)][string] $Path
)
Begin
{
	[string[]] $jsonpath = switch($PropertyName) { '' {,@()} '/' {,@('')}
		default {,@($_ -replace '\A/' -split '/' -replace '~1','/' -replace '~0','~')} }
}
Process
{
	if($Path) {return Get-Content -Path $Path -Raw |ConvertFrom-Json -AsHashtable |Select-Json.ps1 -PropertyName $PropertyName}
	if($null -eq $InputObject) {return}
	if($InputObject -is [string]) {return $InputObject |ConvertFrom-Json -AsHashtable |Select-Json.ps1 -PropertyName $PropertyName}
	if(!$jsonpath.Length) {return $InputObject}
	$selection,$hashmode = $InputObject,($InputObject -is [Collections.IDictionary])
	foreach($segment in $jsonpath)
	{
		if($hashmode) {if(!$selection.ContainsKey($segment)) {return}}
		elseif(!$selection.PSObject.Properties.Match($segment).Count) {return}
		$selection = $selection.$segment
	}
	return $selection
}
