<#
.SYNOPSIS
Serializes complex content into XML elements.

.INPUTS
System.Object (any object) to serialize.

.OUTPUTS
System.String for each XML-serialized value or property.

.FUNCTIONALITY
XML

.EXAMPLE
ConvertTo-XmlElements.ps1 @{html=@{body=@{p='Some text.'}}} -SkipRoot

<html><body><p>Some text.</p></body></html>

.EXAMPLE
[pscustomobject]@{UserName=$env:USERNAME;Computer=$env:COMPUTERNAME} |ConvertTo-XmlElements.ps1

<PSCustomObject>
<UserName>brian</UserName>
<Computer>GRAYSWANDIR</Computer>
</PSCustomObject>

.EXAMPLE
'{"item": {"name": "Test", "id": 1 } }' |ConvertFrom-Json |ConvertTo-XmlElements.ps1 -SkipRoot

<item><id>1</id>
<name>Test</name></item>
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
<#
A hash or XML element or other object to be serialized as XML elements.

Each hash value or object property value may itself be a hash or object or XML element.
#>
[Parameter(Position=0,ValueFromPipeline=$true)] $InputObject,
<#
Specifies how many levels of contained objects are included in the JSON representation.
The value can be any number from 0 to 100. The default value is 2.
ConvertTo-Json emits a warning if the number of levels in an input object exceeds this number.
#>
[ValidateRange('NonNegative')][int] $Depth = 3,
# Do not wrap the input in a root element.
[switch] $SkipRoot
)
Begin
{
	$Script:OFS = [Environment]::NewLine
	function ConvertTo-XmlElement
	{
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(Position=0,ValueFromPipeline=$true)] $InputObject,
		[ValidateRange('NonNegative')][int] $Depth = 3,
		[switch] $SkipRoot # not used here
		)
		if($null -eq $InputObject) {}
		elseif($InputObject -is [Array])
		{ $InputObject |ConvertTo-XmlElement }
		elseif([bool],[byte],[DateTimeOffset],[decimal],[double],[float],[guid],[int],[int16],[long],[sbyte],[timespan],[uint16],[uint32],[uint64] -contains $InputObject.GetType())
		{ [Xml.XmlConvert]::ToString($InputObject) }
		elseif($InputObject -is [datetime])
		{ [Xml.XmlConvert]::ToString($InputObject,'yyyy-MM-dd\THH:mm:ss') }
		elseif($InputObject -is [string] -or $InputObject -is [char])
		{ [Net.WebUtility]::HtmlEncode($InputObject) }
		elseif($InputObject -is [Hashtable] -or $InputObject -is [Collections.Specialized.OrderedDictionary])
		{
			if($Depth -gt 1)
			{
				$InputObject.Keys |
					ForEach-Object {$_ -replace '\A\W+','_' -replace '\W+','-'} |
					ForEach-Object {"<$_>$(ConvertTo-XmlElement $InputObject.$_ -Depth ($Depth-1))</$_>"}
			}
			else
			{
				$InputObject.Keys |
					ForEach-Object {$_ -replace '\A\W+','_' -replace '\W+','-'} |
					ForEach-Object {"<$_>$($InputObject.$_)</$_>"}
			}
		}
		elseif($InputObject -is [PSObject])
		{
			if($Depth -gt 1)
			{
				$InputObject.PSObject.Properties.Name |
					ForEach-Object {$_ -replace '\A\W+','_' -replace '\W+','-'} |
					ForEach-Object {"<$_>$(ConvertTo-XmlElement $InputObject.$_ -Depth ($Depth-1))</$_>"}
			}
			else
			{
				$InputObject.PSObject.Properties.Name |
					ForEach-Object {$_ -replace '\A\W+','_' -replace '\W+','-'} |
					ForEach-Object {"<$_>$($InputObject.$_)</$_>"}
			}
		}
		elseif($InputObject -is [xml])
		{ $InputObject.OuterXml }
		else
		{
			if($Depth -gt 1)
			{
				$InputObject |
					Get-Member -MemberType Properties |
					ForEach-Object {$_.Name -replace '\A\W+','_' -replace '\W+','-'} |
					ForEach-Object {"<$_>$(ConvertTo-XmlElement $InputObject.$_ -Depth ($Depth-1))</$_>"}
			}
			else
			{
				$InputObject |
					Get-Member -MemberType Properties |
					ForEach-Object {$_.Name -replace '\A\W+','_' -replace '\W+','-'} |
					ForEach-Object {"<$_>$($InputObject.$_)</$_>"}
			}
		}
	}
}
Process
{
	if($SkipRoot) {return ConvertTo-XmlElement @PSBoundParameters}
	else
	{
		$root = $InputObject.GetType().Name -replace '\W+','-'
		return "<$root>$Script:OFS$(ConvertTo-XmlElement @PSBoundParameters)$Script:OFS</$root>"
	}
}
