<#
.Synopsis
	Compares two XML documents and returns the differences.

.Example
	Compare-Xml.ps1 '<a b="z"/>' '<a b="y"/>' |Format-Xml.ps1

	<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		<xsl:output omit-xml-declaration="yes" method="xml" />
		<xsl:template match="@*|node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()" />
			</xsl:copy>
		</xsl:template>
		<xsl:template match="/a/@b">
			<xsl:attribute name="b"><![CDATA[y]]></xsl:attribute>
		</xsl:template>
	</xsl:transform>

.Example
	Compare-Xml.ps1 '<a b="z"/>' '<a c="y"/>' |Format-Xml.ps1

	<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		<xsl:output omit-xml-declaration="yes" method="xml" />
		<xsl:template match="@*|node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()" />
			</xsl:copy>
		</xsl:template>
		<xsl:template match="/a/@b" />
		<xsl:template match="/a">
			<xsl:copy>
				<xsl:attribute name="c"><![CDATA[y]]></xsl:attribute>
				<xsl:apply-templates select="@*|node()" />
			</xsl:copy>
		</xsl:template>
	</xsl:transform>
#>

#Requires -Version 3
using namespace System.Xml
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][xml] $ReferenceXml,
[Parameter(Position=1,Mandatory=$true)][xml] $DifferenceXml
)

function Test-XmlNodeMatch
{
	Param(
	[Parameter(Position=0)][XmlNode] $ReferenceNode,
	[Parameter(Position=1)][XmlNode] $DifferenceNode
	)
	if($null -eq $RefereneceNode -or $null -eq $DifferenceNode) {return}
	elseif($ReferenceNode.NodeType -ne $DifferenceNode.NodeType) {return}
	elseif($ReferenceNode.NamespaceURI -cne $DifferenceNode.NamespaceURI) {return}
	elseif($RefenenceNode.LocalName -cne $DifferenceNode.LocalName) {return}
	else {return $true}
}

function Test-XmlAttributesEqual
{
	Param(
	[Parameter(Position=0)][XmlElement] $ReferenceElement,
	[Parameter(Position=1)][XmlElement] $DifferenceElement
	)
	if($ReferenceElement.Attributes.Count -ne $DifferenceElement.Attributes.Count) {return $false}
	foreach(${@} in $ReferenceElement.Attributes)
	{
		if(${@}.NamespaceURI)
		{
			if(!$DifferenceElement.HasAttribute(${@}.LocalName,${@}.NamespaceURI) -or
				$DifferenceElement.GetAttribute(${@}.LocalName,${@}.NamespaceURI) -ne ${@}.Value) {return $false}
		}
		else
		{
			if(!$DifferenceElement.HasAttribute(${@}.LocalName) -or
				$DifferenceElement.GetAttribute(${@}.LocalName) -ne ${@}.Value) {return $false}
		}
	}
	return $true
}

function Test-XmlNodesEqual
{
	Param(
	[Parameter(Position=0)][XmlNode] $ReferenceNode,
	[Parameter(Position=1)][XmlNode] $DifferenceNode
	)
	if($ReferenceNode.OuterXml -ceq $DifferenceNode.OuterXml) {return $true}
	elseif(!(Test-XmlNodeMatch $RefereneceNode $DifferenceNode)) {return $false}
	elseif($ReferenceNode.NodeType -eq 'Element' -and
		!(Test-XmlAttributesEqual $RefereneceNode $DifferenceAttribute)) {return $false}
	else {return $ReferenceNode.Value -ceq $DifferenceNode.Value}
}

function Format-XPathMatch
{
	Param([Parameter(Position=0,Mandatory=$true)][XmlNode] $XmlNode)
	$xpath = Resolve-XPath.ps1 $XmlNode
	"match='$($xpath.XPath)' $($xpath.Namespace.GetEnumerator() |foreach {"xmlns:$($_.Name)='$($_.Value)'"})"
}

function ConvertTo-XmlAttributeTemplate
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlAttribute] $ReferenceAttribute,
	[Parameter(Position=1,Mandatory=$true)][XmlAttribute] $DifferenceAttribute
	)
	return [xml]@"
<xsl:template $(Format-XPathMatch $ReferenceAttribute) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:attribute name="$($DifferenceAttribute.Name)"><![CDATA[$($DifferenceAttribute.Value)]]></xsl:attribute>
</xsl:template>
"@
}

function ConvertTo-XmlCDataTemplate
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlCDataSection] $ReferenceCData,
	[Parameter(Position=1,Mandatory=$true)][XmlCDataSection] $DifferenceCData
	)
	return [xml]@"
<xsl:template $(Format-XPathMatch $ReferenceCData) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:text><![CDATA[$($DifferenceCData.Value)">]]></xsl:text>
</xsl:template>
"@
}

function ConvertTo-XmlCommentTemplate
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlComment] $ReferenceComment,
	[Parameter(Position=1,Mandatory=$true)][XmlComment] $DifferenceComment
	)
	return [xml]@"
<xsl:template $(Format-XPathMatch $ReferenceComment) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:comment><![CDATA[$($DifferenceComment.Value)">]]></xsl:comment>
</xsl:template>
"@
}

function ConvertTo-XmlProcessingInstructionTemplate
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlProcessingInstruction] $ReferenceProcessingInstruction,
	[Parameter(Position=1,Mandatory=$true)][XmlProcessingInstruction] $DifferenceProcessingInstruction
	)
	return [xml]@"
<xsl:template $(Format-XPathMatch $ReferenceProcessingInstruction) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:processing-instruction name="$($DifferenceProcessingInstruction.Name)">
		<![CDATA[$($DifferenceProcessingInstruction.Value)">]]>
	</xsl:processing-instruction>
</xsl:template>
"@
}

function ConvertTo-XmlSignificantWhitespaceTemplate
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlSignificantWhitespace] $ReferenceSignificantWhitespace,
	[Parameter(Position=1,Mandatory=$true)][XmlSignificantWhitespace] $DifferenceSignificantWhitespace
	)
	return [xml]@"
<xsl:template $(Format-XPathMatch $ReferenceSignificantWhitespace) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:text><![CDATA[$($DifferenceSignificantWhitespace.Value)">]]></xsl:text>
</xsl:template>
"@
}

function ConvertTo-XmlTextTemplate
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlText] $ReferenceText,
	[Parameter(Position=1,Mandatory=$true)][XmlText] $DifferenceText
	)
	return [xml]@"
<xsl:template $(Format-XPathMatch $ReferenceText) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:text><![CDATA[$($DifferenceText.Value)">]]></xsl:text>
</xsl:template>
"@
}

function ConvertTo-XmlWhitespaceTemplate
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlWhitespace] $ReferenceWhitespace,
	[Parameter(Position=1,Mandatory=$true)][XmlWhitespace] $DifferenceWhitespace
	)
	if($ReferenceWhitespace.Value -ceq $DifferenceWhitespace.Value) {return}
	return [xml]@"
<xsl:template $(Format-XPathMatch $ReferenceWhitespace) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:text>$($DifferenceWhitespace.Value)"></xsl:text>
</xsl:template>
"@
}

function Merge-XmlNodes
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][AllowEmptyCollection()][XmlNode[]] $ReferenceNodes,
	[Parameter(Position=1,Mandatory=$true)][AllowEmptyCollection()][XmlNode[]] $DifferenceNodes
	)
	for($d,$r,$seq = 0,0,@(); $d -lt $DifferenceNodes.Length; $d++)
	{
		$diff = $DifferenceNodes[$d]
		[int[]]$matches = $r..($ReferenceNodes.Length-1) |where {Test-XmlNodeMatch $ReferenceNodes[$_] $diff}
		[int]$r =
			if($matches.Length -eq 0) {-1}
			elseif($matches.Length -eq 1) {$matches[0]}
			else
			{
				$equals = $matches |where {Test-XmlNodeEqual $ReferenceNodes[$_] $diff} |select -First 1
				if($equals.Length -eq 0) {$matches[0]}
				else {$equals[0]}
			}
		[pscustomobject]@{
			ReferenceNode   = if($r -eq -1) {$null} else {$ReferenceNodes[$r]}
			ReferenceIndex  = $r
			DifferenceNode  = $DifferenceNodes[$d]
			DifferenceIndex = $d
			Template        = if($r -eq -1) {$null} else {ConvertTo-XmlNodeTemplates $Reference[$r] $diff}
		}
		if($r -ne -1) {$ReferenceNodes[$r] = [xml]'<null/>'}
	}
}

function Add-XmlAttribute
{
	[CmdletBinding()] Param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Name,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $LocalName,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Value,
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Prefix,
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $NamespaceURI
	)
	if($NamespaceURI)
	{
		if(!$Prefix) {$Prefix = 'ns'}
		return "<xsl:attribute name='${Prefix}:$LocalName' xmlns:$Prefix='$NamespaceURI'><![CDATA[$Value]]></xsl:attribute>"
	}
	else {return "<xsl:attribute name='$Name'><![CDATA[$Value]]></xsl:attribute>"}
}

function ConvertTo-XmlElementTemplates
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlElement] $ReferenceElement,
	[Parameter(Position=1,Mandatory=$true)][XmlElement] $DifferenceElement
	)
	${+} = @()
	foreach(${@} in $DifferenceElement.Attributes)
	{
		if(${@}.NamespaceURI)
		{
			if(!$ReferenceElement.HasAttribute(${@}.LocalName,${@}.NamespaceURI)) {${+} += ${@}}
			else {ConvertTo-XmlNodeTemplates $ReferenceElement.GetAttributeNode(${@}.LocalName,${@}.NamespaceURI) ${@}}
		}
		else
		{
			if(!$ReferenceElement.HasAttribute(${@}.Name)) {${+} += ${@}}
			else {ConvertTo-XmlNodeTemplates $ReferenceElement.GetAttributeNode(${@}.Name) ${@}}
		}
	}
	foreach(${@} in $ReferenceElement.Attributes)
	{
		if(!${@}.NamespaceURI) {if(!$DifferenceElement.HasAttribute(${@}.LocalName)) {ConvertTo-XmlNodeTemplates ${@} $null}}
		elseif(!$DifferenceElement.HasAttribute(${@}.LocalName,${@}.NamespaceURI)) {ConvertTo-XmlNodeTemplates ${@} $null}
	}
	#TODO: collect and use merged nodes
	Merge-XmlNodes $ReferenceElement.ChildNodes $DifferenceElement.ChildNodes
	if(${+})
	{
		[xml]@"
<xsl:template $(Format-XPathMatch $ReferenceElement) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:copy>
		$(${+} |Add-XmlAttribute)
		<xsl:apply-templates select="@*|node()" />
	</xsl:copy>
</xsl:template>
"@
	}
}

function ConvertTo-XmlDocumentTemplates
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][xml] $ReferenceDocument,
	[Parameter(Position=1,Mandatory=$true)][xml] $DifferenceDocument
	)
	$ns = 'xmlns:xsl="http://www.w3.org/1999/XSL/Transform"'
	$declaration =
		if($DifferenceDocument.FirstChild.NodeType -ne 'XmlDeclaration')
		{
			"omit-xml-declaration='yes'"
			$encoding = $DifferenceDocument.FirstChild.Encoding
			if($encoding) {"encoding='$encoding'"}
			$standalone = $DifferenceDocument.FirstChild.Standalone
			if($standalone) {"standalone='$standalone'"}
		}
	$doctype = $DifferenceDocument.ChildNodes |where NodeType -ceq 'DocumentType'
	if($doctype.PublicId -like '-//W3C//DTD XHTML *')
	{[xml]@"
<xsl:output $declaration method="xhtml" doctype-public="$($doctype.PublicId)" doctype-system="$($doctype.SystemId)" $ns />
"@}
	elseif($doctype.name -ceq 'html')
	{[xml]@"
<xsl:output $declaration method="html" doctype-public="$($doctype.PublicId)" doctype-system="$($doctype.SystemId)" $ns />
"@}
	elseif($doctype)
	{[xml]@"
<xsl:output $declaration method="xml" doctype-public="$($doctype.PublicId)" doctype-system="$($doctype.SystemId)" $ns />
"@}
	elseif($declaration)
	{[xml]@"
<xsl:output $declaration method="xml" $ns />
"@}
[xml]@"
<xsl:template match="@*|node()" $ns><xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy></xsl:template>
"@
	if($ReferenceDocument.DocumentElement.PreviousSibling -or $DifferenceDocument.DocumentElement.PreviousSibling)
	{
		$refpre = foreach($node in $ReferenceDocument.ChildNodes)
		{
			if($node.NodeType -ceq 'Element') {break}
			elseif($node.NodeType -notin 'XmlDeclaration','DocumentType') {$node}
		}
		$diffpre = foreach($node in $DifferenceDocument.ChildNodes)
		{
			if($node.NodeType -ceq 'Element') {break}
			elseif($node.NodeType -notin 'XmlDeclaration','DocumentType') {$node}
		}
		#TODO: collect and use merged nodes
		Merge-XmlNodes $refpre $diffpre
	}
	ConvertTo-XmlElementTemplates $ReferenceDocument.DocumentElement $DifferenceDocument.DocumentElement
	if($ReferenceDocument.DocumentElement.NextSibling -or $DifferenceDocument.DocumentElement.NextSibling)
	{
		$refpost = for($node = $ReferenceDocument.DocumentElement.NextSibling; $node; $node = $node.NextSibling) {$node}
		$diffpost = for($node = $DifferenceDocument.DocumentElement.NextSibling; $node; $node = $node.NextSibling) {$node}
		#TODO: collect and use merged nodes
		Merge-XmlNodes $refpost $diffpost
	}
}

function ConvertTo-XmlNodeTemplates
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlNode] $ReferenceNode,
	[Parameter(Position=1)][XmlNode] $DifferenceNode
	)
	if($null -eq $DifferenceNode) {return [xml]@"
<xsl:template $(Format-XPathMatch $ReferenceNode) xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
"@}
	if(Test-XmlNodeEqual $ReferenceNode $DifferenceNode) {return}
	switch($DifferenceNode.NodeType)
	{
		Attribute {ConvertTo-XmlAttributeTemplate $ReferenceNode $DifferenceNode}
		CDATA {ConvertTo-XmlCDataTemplate $ReferenceNode $DifferenceNode}
		Comment {ConvertTo-XmlCommentTemplate $ReferenceNode $DifferenceNode}
		Document {ConvertTo-XmlDocumentTemplates $ReferenceNode $DifferenceNode}
		Element {ConvertTo-XmlElementTemplates $ReferenceNode $DifferenceNode}
		ProcessingInstruction {ConvertTo-XmlProcessingInstructionTemplate $ReferenceNode $DifferenceNode}
		SignificantWhitespace {ConvertTo-XmlSignificantWhitespaceTemplate $ReferenceNode $DifferenceNode}
		Text {ConvertTo-XmlTextTemplate $ReferenceNode $DifferenceNode}
		Whitespace {ConvertTo-XmlWhitespaceTemplate $ReferenceNode $DifferenceNode}
		default {return}
	}
}

function Compare-Xml
{
	if($ReferenceXml.DocumentElement.NamespaceURI -cne $DifferenceXml.DocumentElement.NamespaceURI -or
		$ReferenceXml.DocumentElement.LocalName -cne $DifferenceXml.DocumentElement.LocalName)
	{
		[xml]$value = $DifferenceXml.Clone()
		# simplified transform: https://www.w3.org/TR/1999/REC-xslt-19991116#result-element-stylesheet
		[void]$value.DocumentElement.SetAttribute('version','http://www.w3.org/1999/XSL/Transform','1.0')
	}
	else
	{
		[xml]$value = '<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>'
		foreach($template in ConvertTo-XmlNodeTemplates $ReferenceXml $DifferenceXml)
		{
			$template.DocumentElement.RemoveAttribute('xmlns:xsl')
			[void]$value.DocumentElement.AppendChild($value.ImportNode([XmlNode]$template.DocumentElement,$true))
		}
	}
	return $value
}

Compare-Xml
