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

<html>
<body>
<p>Some text.</p>
</body>
</html>

.EXAMPLE
[pscustomobject]@{UserName='zaphodb';Computer='eddie'} |ConvertTo-XmlElements.ps1

<PSCustomObject>
<UserName>zaphodb</UserName>
<Computer>eddie</Computer>
</PSCustomObject>

.EXAMPLE
'{"item": {"name": "Test", "id": 1 } }' |ConvertFrom-Json |ConvertTo-XmlElements.ps1 -SkipRoot

<item>
<name>Test</name>
<id>1</id>
</item>
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

	function ConvertTo-CompoundXmlElement
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipeline=$true)][string] $PropertyName,
		[switch] $IsFirst
		)
		Begin {if(!$IsFirst) {Write-Output ''}} # adds OFS
		Process
		{
			$name = $PropertyName -replace '\[\]','Array' -replace '\A\W+','_' -replace '\W+','-'
			Write-Output "<$name>$(ConvertTo-XmlElement $InputObject.$PropertyName -Depth ($Depth-1))</$name>"
		}
		End {if(!$IsFirst) {Write-Output ''}} # adds OFS
	}

	function ConvertTo-SimpleXmlElement
	{
		[CmdletBinding()] Param(
		[Parameter(ValueFromPipeline=$true)][string] $PropertyName,
		[switch] $IsFirst
		)
		Begin {if(!$IsFirst) {Write-Output ''}} # adds OFS
		Process
		{
			$name = $PropertyName -replace '\[\]','Array' -replace '\A\W+','_' -replace '\W+','-'
			Write-Output "<$name>$($InputObject.$PropertyName)</$name>"
		}
		End {if(!$IsFirst) {Write-Output ''}} # adds OFS
	}

	filter ConvertTo-XmlElement
	{
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(Position=0,ValueFromPipeline=$true)] $InputObject,
		[ValidateRange('NonNegative')][int] $Depth = 3,
		[switch] $IsFirst,
		[switch] $SkipRoot # not used here
		)
		if($null -eq $InputObject) {return '<null />'}
		elseif($InputObject -is [DBNull]) {return '<DBNull />'}
		elseif($InputObject -is [Array])
		{ $InputObject |ConvertTo-XmlElement |ForEach-Object -Begin {''} -Process {"<Item>$_</Item>"} -End {''} }
		elseif([bool],[byte],[DateTimeOffset],[decimal],[double],[float],[guid],[int],[int16],[long],[sbyte],[timespan],[uint16],[uint32],[uint64] -contains $InputObject.GetType())
		{ [Xml.XmlConvert]::ToString($InputObject) }
		elseif($InputObject -is [datetime])
		{ [Xml.XmlConvert]::ToString($InputObject,'yyyy-MM-dd\THH:mm:ss') }
		elseif($InputObject -is [string] -or $InputObject -is [char])
		{ [Net.WebUtility]::HtmlEncode($InputObject) }
		elseif($InputObject -is [Hashtable] -or $InputObject -is [Collections.Specialized.OrderedDictionary])
		{
			if($Depth -gt 1) {$InputObject.Keys |ConvertTo-CompoundXmlElement -IsFirst:$IsFirst}
			else {$InputObject.Keys |ConvertTo-SimpleXmlElement -IsFirst:$IsFirst}
		}
		elseif($InputObject -is [PSObject])
		{
			if(!@($InputObject.PSObject.Properties)) {return}
			elseif($Depth -gt 1) {$InputObject.PSObject.Properties.Name |ConvertTo-CompoundXmlElement -IsFirst:$IsFirst}
			else {$InputObject.PSObject.Properties.Name |ConvertTo-SimpleXmlElement -IsFirst:$IsFirst}
		}
		elseif($InputObject -is [xml])
		{ $InputObject.OuterXml }
		else
		{
			if(!@($InputObject.PSObject.Properties)) {return}
			elseif($Depth -gt 1)
			{
				$InputObject |
					Get-Member -MemberType Properties |
					Select-Object -ExpandProperty Name |
					ConvertTo-CompoundXmlElement -IsFirst:$IsFirst
			}
			else
			{
				$InputObject |
					Get-Member -MemberType Properties |
					Select-Object -ExpandProperty Name |
					ConvertTo-SimpleXmlElement -IsFirst:$IsFirst
			}
		}
	}
}
Process
{
	if($null -eq $InputObject) {return '<null />'}
	elseif($InputObject -is [DBNull]) {return '<DBNull />'}
	elseif($SkipRoot) {return "$(ConvertTo-XmlElement @PSBoundParameters -IsFirst)"}
	else
	{
		$root = $InputObject.GetType().Name -replace '\[\]','Array' -replace '\A\W+','_' -replace '\W+','-'
		return "<$root>$(ConvertTo-XmlElement @PSBoundParameters)</$root>"
	}
}

