<#
.Synopsis
	Returns the XPath of the location of an XML node.

.Parameter XmlNode
	An XML node to retrieve the XPath for.

.Link
	https://docs.microsoft.com/dotnet/api/system.xml.xmlnode

.Example
	'<a><b c="value"/></a>' |Select-Xml //@c |Resolve-Xml.ps1

	/a/b/@c

.Example
	'<a>one<!-- two -->three</a>' |Select-Xml '//text()' |Resolve-XPath.ps1

	/a/text()[1]
	/a/text()[2]
#>

#Requires -Version 3
using namespace System.Xml
[CmdletBinding()] Param(
[Alias('Node')][Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[XmlNode] $XmlNode
)
Begin
{
	function Measure-XmlNodePosition([Parameter(Position=0,Mandatory=$true)][XmlNode]$Node)
	{
		if(!($Node.PreviousSibling -or $Node.NextSibling)) {return}
		for($i,$n = 0,$Node; $n; $n = $n.PreviousSibling)
		{
			if($n.NodeType -eq $Node.NodeType -and $n.get_Name() -eq $Node.get_Name()) {$i++}
		}
		if($i -gt 1) {return "[$i]"}
		for($i,$n = 0,$Node; $n; $n = $n.NextSibling)
		{
			if($n.NodeType -eq $Node.NodeType -and $n.get_Name() -eq $Node.get_Name()) {$i++}
		}
		if($i -gt 1) {return '[1]'}
		else {return}
	}

	function Resolve-XmlNode([Parameter(Position=0,Mandatory=$true)][XmlNode]$Node)
	{
		switch($Node.NodeType)
		{
			Attribute {return "$(Resolve-XmlNode $Node.OwnerElement)/@$($Node.get_Name())"}
			CDATA {return "$(Resolve-XmlNode $Node.ParentNode)/text()$(Measure-XmlNodePosition $Node)"}
			Comment {return "$(Resolve-XmlNode $Node.ParentNode)/comment()$(Measure-XmlNodePosition $Node)"}
			Document {if((Get-PSCallStack)[1].Command -ne $MyInvocation.MyCommand.get_Name()){return '/'}}
			Element {return "$(Resolve-XmlNode $Node.ParentNode)/$($Node.get_Name())$(Measure-XmlNodePosition $Node)"}
			ProcessingInstruction {return
				"$(Resolve-XmlNode $Node.ParentNode)/processing-instruction('$($Node.get_Name())')$(Measure-XmlNodePosition $Node)"}
			SignificantWhitespace {return "$(Resolve-XmlNode $Node.ParentNode)/text()$(Measure-XmlNodePosition $Node)"}
			Text {return "$(Resolve-XmlNode $Node.ParentNode)/text()$(Measure-XmlNodePosition $Node)"}
			Whitespace {return "$(Resolve-XmlNode $Node.ParentNode)/text()$(Measure-XmlNodePosition $Node)"}
			default {return}
		}
	}
}
Process
{
	Resolve-XmlNode $XmlNode
}
