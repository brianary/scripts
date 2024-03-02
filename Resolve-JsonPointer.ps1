<#
.SYNOPSIS
Returns matching JSON Pointer paths, given a JSON Pointer path with wildcards.

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
'[8, 7, 6]' |Resolve-JsonPointer.ps1 /-

/3

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
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": [7, 8, 9]}}}' |ConvertFrom-Json |Resolve-JsonPointer.ps1 /?/ZZ*/*BC/-

/b/ZZ~1ZZ/AD~0BC/3

.EXAMPLE
Resolve-JsonPointer.ps1 /* -Path .\test\data\sample-openapi.json -IncludePath

Path                                     Pointer
----                                     -------
A:\Scripts\test\data\sample-openapi.json /openapi
A:\Scripts\test\data\sample-openapi.json /info
A:\Scripts\test\data\sample-openapi.json /tags
A:\Scripts\test\data\sample-openapi.json /paths
A:\Scripts\test\data\sample-openapi.json /components
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
# Indicates that the source file path should be included in the output, if available.
[switch] $IncludePath
)
Begin
{
	[string[]] $jsonpath = switch($JsonPointer) { '' {,@()}
		default {,@($_ -replace '\A/' -replace '~4','[[]' -replace '~3','[*]' -replace '~2','[?]' -split '/' -replace '~1','/' -replace '~0','~')} }

	function Resolve-Segment
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0)] $InputObject,
		[Parameter(Position=1)][string] $Segment,
		[Parameter(Position=2)][string[]] $Segments,
		[Parameter(Position=3)][string] $JsonPointer
		)
		$pointer = "$JsonPointer/$($segment -replace '~','~0' -replace '/','~1')"
		if($InputObject -is [array])
		{
			if($Segment -eq '-') {return Resolve-Pointer -InputObject $null -Segments $Segments -JsonPointer "$JsonPointer/$($InputObject.Count)"}
			elseif(![int]::TryParse($Segment,[ref]$Segment)) {return}
			elseif($InputObject.Length -le $Segment) {return}
			else {return Resolve-Pointer -InputObject ($InputObject[$Segment]) -Segments $Segments -JsonPointer $pointer}
		}
		elseif($InputObject -is [Collections.IDictionary])
		{
			if(!$InputObject.ContainsKey($Segment)) {return}
			else {return Resolve-Pointer -InputObject ($InputObject[$Segment]) -Segments $Segments -JsonPointer $pointer}
		}
		else
		{
			return $InputObject.PSObject.Properties.Match($Segment) |
				Select-Object -ExpandProperty Value |
				Resolve-Pointer -Segments $Segments -JsonPointer $pointer
		}
	}

	function Resolve-Wildcard
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0)] $InputObject,
		[Parameter(Position=1)][string] $Segment,
		[Parameter(Position=2)][string[]] $Segments,
		[Parameter(Position=3)][string] $JsonPointer
		)
		if($InputObject -is [array])
		{
			return 0..($InputObject.Length-1) -like $segment |ForEach-Object {
				$pointer = "$JsonPointer/$_"
				Resolve-Pointer -InputObject $InputObject[$_] -Segments $Segments -JsonPointer $pointer}
		}
		elseif($InputObject -is [Collections.IDictionary])
		{
			return $InputObject.Keys -like $segment |ForEach-Object {
				$pointer = "$JsonPointer/$($_ -replace '~','~0' -replace '/','~1')"
				Resolve-Pointer -InputObject $InputObject[$_] -Segments $Segments -JsonPointer $pointer}
		}
		else
		{
			return $InputObject.PSObject.Properties.Match($segment) |ForEach-Object {
				$pointer = "$JsonPointer/$($_.Name -replace '~','~0' -replace '/','~1')"
				Resolve-Pointer -InputObject $_.Value -Segments $Segments -JsonPointer $pointer}
		}
	}

	filter Resolve-Pointer
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipeline=$true)] $InputObject,
		[string[]] $Segments,
		[string] $JsonPointer = ''
		)
		if(!$Segments.Count) {return $JsonPointer}
		$segment,$Segments = $Segments
		if($null -eq $Segments) {[string[]]$Segments = @()}
		if($segment -match '[?*[]') {Resolve-Wildcard -InputObject $InputObject -Segment $segment -Segments $Segments -JsonPointer $JsonPointer}
		else {Resolve-Segment -InputObject $InputObject -Segment $segment -Segments $Segments -JsonPointer $JsonPointer}
	}
}
Process
{
	if($Path)
	{
		if($IncludePath)
		{
			return Resolve-Path -Path $Path -PipelineVariable file |
				Get-Content -Raw |
				ForEach-Object {Resolve-Pointer -InputObject ($_ |ConvertFrom-Json -AsHashtable) -Segments $jsonpath} |
				ForEach-Object {[pscustomobject]@{Path=$file.Path; Pointer=$_}}
		}
		else
		{
			return Resolve-Path -Path $Path |
				Get-Content -Raw |
				ForEach-Object {Resolve-Pointer -InputObject ($_ |ConvertFrom-Json -AsHashtable) -Segments $jsonpath}
		}
	}
	if($null -eq $InputObject) {return}
	if($InputObject -is [string])
	{
		return Resolve-Pointer -InputObject ($InputObject |ConvertFrom-Json -AsHashtable) -Segments $jsonpath
	}
	if(!$jsonpath.Length) {return $JsonPointer}
	return Resolve-Pointer -InputObject $InputObject -Segments $jsonpath
}
