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
ConvertTo-XmlElements.ps1 @{html=@{body=@{p='Some text.'}}}

<html><body><p>Some text.</p></body></html>

.EXAMPLE
[pscustomobject]@{UserName=$env:USERNAME;Computer=$env:COMPUTERNAME} |ConvertTo-XmlElements.ps1

<Computer>COMPUTERNAME</Computer>
<UserName>username</UserName>

.EXAMPLE
'{"item": {"name": "Test", "id": 1 } }' |ConvertFrom-Json |ConvertTo-XmlElements.ps1

<item><id>1</id>
<name>Test</name></item>
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
<#
A hash or XML element or other object to be serialized as XML elements.

Each hash value or object property value may itself be a hash or object or XML element.
#>
[Parameter(Position=0,ValueFromPipeline=$true)] $Value,
<#
Specifies how many levels of contained objects are included in the JSON representation.
The value can be any number from 0 to 100. The default value is 2.
ConvertTo-Json emits a warning if the number of levels in an input object exceeds this number.
#>
[ValidateRange('NonNegative')][int] $Depth = 3
)
Begin {$Script:OFS = "`n"}
Process
{
	if($null -eq $Value) {}
	elseif($Value -is [Array])
	{ $Value |ConvertTo-XmlElements.ps1 }
	elseif([bool],[byte],[DateTimeOffset],[decimal],[double],[float],[guid],[int],[int16],[long],[sbyte],[timespan],[uint16],[uint32],[uint64] -contains $Value.GetType())
	{ [Xml.XmlConvert]::ToString($Value) }
	elseif($Value -is [datetime])
	{ [Xml.XmlConvert]::ToString($Value,'yyyy-MM-dd\THH:mm:ss') }
	elseif($Value -is [string] -or $Value -is [char])
	{ [Net.WebUtility]::HtmlEncode($Value) }
	elseif($Value -is [Hashtable] -or $Value -is [Collections.Specialized.OrderedDictionary])
	{
		if($Depth -gt 1)
		{
			$Value.Keys |
				ForEach-Object {$_ -replace '\A\W+','_' -replace '\W+','-'} |
				ForEach-Object {"<$_>$(ConvertTo-XmlElements.ps1 $Value.$_ -Depth ($Depth-1))</$_>"}
		}
		else
		{
			$Value.Keys |
				ForEach-Object {$_ -replace '\A\W+','_' -replace '\W+','-'} |
				ForEach-Object {"<$_>$($Value.$_)</$_>"}
		}
	}
	elseif($Value -is [PSObject])
	{
		if($Depth -gt 1)
		{
			$Value.PSObject.Properties.Name |
				ForEach-Object {$_ -replace '\A\W+','_' -replace '\W+','-'} |
				ForEach-Object {"<$_>$(ConvertTo-XmlElements.ps1 $Value.$_ -Depth ($Depth-1))</$_>"}
		}
		else
		{
			$Value.PSObject.Properties.Name |
				ForEach-Object {$_ -replace '\A\W+','_' -replace '\W+','-'} |
				ForEach-Object {"<$_>$($Value.$_)</$_>"}
		}
	}
	elseif($Value -is [xml])
	{ $Value.OuterXml }
	else
	{
		if($Depth -gt 1)
		{
			$Value |
				Get-Member -MemberType Properties |
				ForEach-Object {$_.Name -replace '\A\W+','_' -replace '\W+','-'} |
				ForEach-Object {"<$_>$(ConvertTo-XmlElements.ps1 $Value.$_ -Depth ($Depth-1))</$_>"}
		}
		else
		{
			$Value |
				Get-Member -MemberType Properties |
				ForEach-Object {$_.Name -replace '\A\W+','_' -replace '\W+','-'} |
				ForEach-Object {"<$_>$($Value.$_)</$_>"}
		}
	}
}
