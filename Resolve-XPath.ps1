<#
.SYNOPSIS
Returns the XPath of the location of an XML node.

.INPUTS
System.Xml.XmlNode or property of that type named XmlNode or Node.

.OUTPUTS
System.Management.Automation.PSCustomObject with the following properties:

* XPath: The XPath that locates the node.
* Namespace: The namespace table used to select the node.

.FUNCTIONALITY
XML

.LINK
https://docs.microsoft.com/dotnet/api/system.xml.xmlnode

.EXAMPLE
'<a><b c="value"/></a>' |Select-Xml //@c |Resolve-XPath.ps1

/a/b/@c

.EXAMPLE
'<a>one<!-- two -->three</a>' |Select-Xml '//text()' |Resolve-XPath.ps1

/a/text()[1]
/a/text()[2]
#>

#Requires -Version 3
using namespace System.Xml
[CmdletBinding()][OutputType([string])] Param(
# An XML node to retrieve the XPath for.
[Alias('Node')][Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[XmlNode] $XmlNode
)
Begin
{
	function Test-NodeMatch([XmlNode]$ReferenceNode,[XmlNode]$DifferenceNode)
	{
		return $ReferenceNode.get_NodeType() -eq $DifferenceNode.get_NodeType() -and
			$ReferenceNode.get_LocalName() -eq $DifferenceNode.get_LocalName() -and
			$ReferenceNode.get_NamespaceURI() -eq $DifferenceNode.get_NamespaceURI()
	}

	function Measure-XmlNodePosition([Parameter(Position=0,Mandatory=$true)][XmlNode]$Node)
	{
		if(!($Node.PreviousSibling -or $Node.NextSibling)) {return}
		for($i,$n = 0,$Node; $n; $n = $n.PreviousSibling) {if(Test-NodeMatch $n $Node) {$i++}}
		if($i -gt 1) {return "[$i]"}
		for($i,$n = 0,$Node.NextSibling; $n; $n = $n.NextSibling) {if(Test-NodeMatch $n $Node) {$i++; break}}
		if($i -gt 0) {return '[1]'}
		else {return}
	}

	function Get-NodeName([Parameter(Position=0,Mandatory=$true)][XmlNode]$Node,
		[Parameter(Position=1)][Collections.Hashtable]$Namespace=@{})
	{
		if($Node.get_NamespaceURI() -and !$Node.get_Prefix() -and ($Node.get_NodeType() -ne 'Attribute' -or
			$Node.get_NamespaceURI() -ne $Node.OwnerElement.get_NamespaceURI()))
		{
			if($Node.get_NamespaceURI() -in $Namespace.Values)
			{
				$prefix = $Namespace.GetEnumerator() |where Value -eq $Node.get_NamespaceURI() |select -First 1 -exp Key
			}
			else
			{
				$prefix = ([uri]$Node.get_NamespaceURI()).Segments |where {$_ -match '\A[A-Za-z]\w*\z'} |select -Last 1
				if(!$prefix) {$prefix = 'ns'}
				while($Namespace.ContainsKey($prefix)) {$prefix += Get-Random -Maximum 99}
				$Namespace.Add($prefix,$Node.get_NamespaceURI())
			}
			return $prefix + ':' + $Node.get_LocalName()
		}
		else
		{
			if($Node.get_NamespaceURI() -and !$Namespace.ContainsKey($Node.get_Prefix()))
			{$Namespace.Add($Node.get_Prefix(),$Node.get_NamespaceURI())}
			return $Node.get_Name()
		}
	}

	function Resolve-XmlNode([Parameter(Position=0,Mandatory=$true)][XmlNode]$Node,
		[Parameter(Position=1)][Collections.Hashtable]$Namespace=@{},
		[switch]$AsObject)
	{
		$name = Get-NodeName $Node $Namespace
		$xpath = switch($Node.get_NodeType())
		{
			Attribute {"$(Resolve-XmlNode $Node.OwnerElement $Namespace)/@$name"}
			CDATA {"$(Resolve-XmlNode $Node.ParentNode)/text()$(Measure-XmlNodePosition $Node)"}
			Comment {"$(Resolve-XmlNode $Node.ParentNode)/comment()$(Measure-XmlNodePosition $Node)"}
			Document {if($AsObject){'/'}else{$null}}
			Element {"$(Resolve-XmlNode $Node.ParentNode $Namespace)/$name$(Measure-XmlNodePosition $Node)"}
			ProcessingInstruction {
				"$(Resolve-XmlNode $Node.ParentNode)/processing-instruction('$name')$(Measure-XmlNodePosition $Node)"}
			SignificantWhitespace {"$(Resolve-XmlNode $Node.ParentNode)/text()$(Measure-XmlNodePosition $Node)"}
			Text {"$(Resolve-XmlNode $Node.ParentNode)/text()$(Measure-XmlNodePosition $Node)"}
			Whitespace {"$(Resolve-XmlNode $Node.ParentNode)/text()$(Measure-XmlNodePosition $Node)"}
			default {$null}
		}
		if($AsObject) {[pscustomobject]@{XPath=$xpath;Namespace=$Namespace}} else {$xpath}
	}
}
Process
{
	Resolve-XmlNode $XmlNode -AsObject
}
