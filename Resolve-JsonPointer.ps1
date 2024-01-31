<#
.SYNOPSIS
Returns a value from a JSON string or file.

.INPUTS
System.String containing JSON, or
System.Collections.Hashtable parsed from JSON, or
System.Management.Automation.PSObject parsed from JSON.

.OUTPUTS
System.String of the full JSON Pointer matched.

.FUNCTIONALITY
Json

.LINK
https://www.rfc-editor.org/rfc/rfc6901

.LINK
ConvertFrom-Json

.EXAMPLE
'{a:1}' |Resolve-JsonPointer.ps1 /*

/a

.EXAMPLE
Resolve-JsonPointer.ps1 /powershell.*.preset -Path ./.vscode/settings.json

/powershell.codeFormatting.preset

.EXAMPLE
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Resolve-JsonPointer.ps1 /*/ZZ?ZZ/AD?BC

/b/ZZ~1ZZ/AD~0BC

.EXAMPLE
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Resolve-JsonPointer.ps1 /[bc]/ZZ?ZZ

/b/ZZ~1ZZ

.EXAMPLE
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |ConvertFrom-Json |Resolve-JsonPointer.ps1 /?/ZZ*/*BC

/b/ZZ~1ZZ/AD~0BC
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
[Parameter(ParameterSetName='Path',Mandatory=$true)][string] $Path
)
Begin
{
	[string[]] $jsonpath = switch($JsonPointer) { '' {,@()}
		default {,@($_ -replace '\A/' -replace '~4','[[]' -replace '~3','[*]' -replace '~2','[?]' -split '/' -replace '~1','/' -replace '~0','~')} }

	filter Resolve-Next
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipeline=$true)] $InputObject,
		[string[]] $Segments,
		[string] $JsonPointer = ''
		)
		if(!$Segments.Count) {return $JsonPointer}
		$segment,$Segments = $Segments
		if($null -eq $Segments) {[string[]]$Segments = @()}
		if($segment -match '[?*[]')
		{
			if($InputObject -is [array])
			{
				return 0..($InputObject.Length-1) -like $segment |ForEach-Object {
					$pointer = "$JsonPointer/$($_ -replace '~','~0' -replace '/','~1')"
					$InputObject[$_] |Resolve-Next -Segments $Segments -JsonPointer $pointer}
			}
			elseif($InputObject -is [Collections.IDictionary])
			{
				return $InputObject.Keys -like $segment |ForEach-Object {
					$pointer = "$JsonPointer/$($_ -replace '~','~0' -replace '/','~1')"
					$InputObject[$_] |Resolve-Next -Segments $Segments -JsonPointer $pointer}
			}
			else
			{
				return $InputObject.PSObject.Properties.Match($segment) |ForEach-Object {
					$pointer = "$JsonPointer/$($_.Name -replace '~','~0' -replace '/','~1')"
					$_.Value |Resolve-Next -Segments $Segments -JsonPointer $pointer}
			}
		}
		else
		{
			$JsonPointer = "$JsonPointer/$($segment -replace '~','~0' -replace '/','~1')"
			if($InputObject -is [array])
			{
				if(![int]::TryParse($segment,[ref]$segment)) {return}
				elseif($InputObject.Length -le $segment) {return}
				else {return Resolve-Next -InputObject ($InputObject[$segment]) -Segments $Segments -JsonPointer $JsonPointer}
			}
			elseif($InputObject -is [Collections.IDictionary])
			{
				if(!$InputObject.ContainsKey($segment)) {return}
				else {return Resolve-Next -InputObject ($InputObject[$segment]) -Segments $Segments -JsonPointer $JsonPointer}
			}
			else
			{
				return $InputObject.PSObject.Properties.Match($segment) |
					Select-Object -ExpandProperty Value |
					Resolve-Next -Segments $Segments -JsonPointer $JsonPointer
			}
		}
	}
}
Process
{
	if($Path)
	{
		return Get-Content -Path $Path -Raw |
			ConvertFrom-Json -AsHashtable |
			Resolve-Next -Segments $jsonpath
	}
	if($null -eq $InputObject) {return}
	if($InputObject -is [string])
	{
		return $InputObject |
			ConvertFrom-Json -AsHashtable |
			Resolve-Next -Segments $jsonpath
	}
	if(!$jsonpath.Length) {return $JsonPointer}
	return Resolve-Next -InputObject $InputObject -Segments $jsonpath
}
