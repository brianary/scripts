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
https://www.rfc-editor.org/rfc/rfc6901

.LINK
ConvertFrom-Json

.EXAMPLE
'true' |Select-Json.ps1  # default selection is entire parsed JSON document

True

.EXAMPLE
'{"":3.14}' |Select-Json.ps1 /

3.14

.EXAMPLE
Select-Json.ps1 /powershell.codeFormatting.preset -Path ./.vscode/settings.json

Allman

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

.EXAMPLE
'{d:{a:{b:1,c:{"$ref":"#/d/c"}},c:{d:{"$ref":"#/d/two"}},two:2}}' |Select-Json.ps1 /*/a/c/* -FollowReferences

2
#>

#Requires -Version 7
[CmdletBinding()][OutputType([bool],[long],[double],[string],[Management.Automation.OrderedHashtable])] Param(
<#
The full path name of the property to get, as a JSON Pointer,
modified to support wildcards: ~0 = ~  ~1 = /  ~2 = ?  ~3 = *  ~4 = [
#>
[Parameter(Position=0)][Alias('Name')][AllowEmptyString()][ValidatePattern('\A(?:|/(?:[^~]|~[0-4])*)\z')]
[string] $JsonPointer = '',
# The JSON (string or parsed object/hashtable) to get the value from.
[Parameter(ParameterSetName='InputObject',ValueFromPipeline=$true)] $InputObject,
# A JSON file to update.
[Parameter(ParameterSetName='Path',Mandatory=$true)][string] $Path,
# Indicates that references should be followed.
[Alias('FollowRefs','References')][switch] $FollowReferences
)
Begin
{
	[string[]] $jsonpath = switch($JsonPointer) { '' {,@()}
		default {,@($_ -replace '\A/' -replace '~4','[[]' -replace '~3','[*]' -replace '~2','[?]' -split '/' -replace '~1','/' -replace '~0','~')} }

	function Get-ReferenceUri
	{
		[CmdletBinding()] Param($InputObject)
		if($InputObject -is [array]) {return}
		if($InputObject -is [Collections.IDictionary] -and $InputObject.ContainsKey('$ref')) {return $InputObject['$ref']}
		if($InputObject.PSObject.Properties.Match('$ref').Count) {return $InputObject.'$ref'}
	}

	function Get-Reference
	{
		[CmdletBinding()] Param([uri] $ReferenceUri, $Root)
		$source,$pointer = switch($ReferenceUri)
		{
			{$null -eq $_} {$Root,''; continue}
			{$_.OriginalString -like '#*'} {$Root,($_.OriginalString -replace '\A#')}
			{$_.IsFile} {(Get-Content $_.LocalPath -Raw |ConvertFrom-Json -AsHashtable),($_.Fragment -replace '\A*')}
			default {(Invoke-RestMethod $ReferenceUri),($_.Fragment -replace '\A#')}
		}
		return $source |Select-Json.ps1 $pointer
	}

	function Select-Segment
	{
		[CmdletBinding()] Param([Parameter(Position=0)] $InputObject, [Parameter(Position=1)][string] $Segment)
		if($InputObject -is [array])
		{
			if(![int]::TryParse($Segment,[ref]$Segment)) {return}
			elseif($InputObject.Length -le $Segment) {return}
			else {return $InputObject[$Segment]}
		}
		elseif($InputObject -is [Collections.IDictionary])
		{
			if(!$InputObject.ContainsKey($Segment)) {return}
			else {return $InputObject[$Segment]}
		}
		else
		{
			return $InputObject.PSObject.Properties.Match($Segment) |
				Select-Object -ExpandProperty Value
		}
	}

	function Select-Wildcard
	{
		[CmdletBinding()] Param([Parameter(Position=0)] $InputObject, [Parameter(Position=1)][string] $Segment)
		if($InputObject -is [array])
		{
			return 0..($InputObject.Length-1) -like $Segment |ForEach-Object {$InputObject[$_]}
		}
		elseif($InputObject -is [Collections.IDictionary])
		{
			return $InputObject.Keys -like $Segment |ForEach-Object {$InputObject[$_]}
		}
		else
		{
			return $InputObject.PSObject.Properties.Match($Segment) |
				Select-Object -ExpandProperty Value
		}
	}

	filter Select-Pointer
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipeline=$true)] $InputObject,
		[string[]] $Segments
		)
		if($FollowReferences)
		{
			$refUri = Get-ReferenceUri $InputObject
			if($refUri) {return Get-Reference -ReferenceUri $refUri -Root $Script:Root |Select-Pointer -Segments $Segments}
		}
		if(!$Segments.Count) {return $InputObject}
		$segment,$Segments = $Segments
		if($null -eq $Segments) {[string[]]$Segments = @()}
		if($segment -match '[?*[]') {Select-Wildcard $InputObject $segment |Select-Pointer -Segments $Segments}
		else {Select-Segment $InputObject $segment |Select-Pointer -Segments $Segments}
	}
}
Process
{
	if($Path)
	{
		return Resolve-Path -Path $Path |
			Get-Content -Raw |
			ForEach-Object {$_ |ConvertFrom-Json -AsHashtable |
				Select-Json.ps1 -JsonPointer $JsonPointer -FollowReferences:$FollowReferences}
	}
	if($null -eq $InputObject) {return}
	if($InputObject -is [string])
	{
		if($InputObject.StartsWith(([char]0xFEFF))) {$InputObject = $InputObject.Substring(1)}
		return $InputObject |
			ConvertFrom-Json -AsHashtable |
			Select-Json.ps1 -JsonPointer $JsonPointer -FollowReferences:$FollowReferences
	}
	if(!$jsonpath.Length) {return $InputObject}
	$Script:Root = $InputObject
	return Select-Pointer -InputObject $InputObject -Segments $jsonpath
}
