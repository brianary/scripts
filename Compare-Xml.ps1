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

function Add-XmlNamespace
{
	[CmdletBinding()] Param(
	[Parameter(Position=0,ValueFromPipelineByPropertyName=$true)][string] $Prefix,
	[Parameter(Position=1,ValueFromPipelineByPropertyName=$true)][string] $NamespaceURI,
	[Parameter(ValueFromPipeline=$true)][XmlNode] $Node
	)
	if($Prefix) {return "xmlns:$Prefix='$NamespaceURI'"}
}

function Compare-XmlAttribute
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlAttribute] $ReferenceAttribute,
	[Parameter(Position=1)][XmlAttribute] $DifferenceAttribute
	)
	if($DifferenceAttribute -eq $null)
	{return [xml]@"
<xsl:template match="$(Resolve-XPath.ps1 $ReferenceAttribute)"
	$($DifferenceAttribute |Add-XmlNamespace) xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>
"@}
	if($ReferenceAttribute.LocalName -ceq $DifferenceAttribute.LocalName -and
		$ReferenceAttribute.NamespaceURI -ceq $DifferenceAttribute.NamespaceURI -and
		$ReferenceAttribute.Value -ceq $DifferenceAttribute.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-XPath.ps1 $ReferenceAttribute)"
	$($DifferenceAttribute |Add-XmlNamespace) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:attribute name="$($DifferenceAttribute.Name)"><![CDATA[$($DifferenceAttribute.Value)]]></xsl:attribute>
</xsl:template>
"@
}

function Compare-XmlCData
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlCDataSection] $ReferenceCData,
	[Parameter(Position=1,Mandatory=$true)][XmlCDataSection] $DifferenceCData
	)
	if($ReferenceCData.Value -ceq $DifferenceCData.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-XPath.ps1 $ReferenceCData)" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:text><![CDATA[$($DifferenceCData.Value)">]]></xsl:text>
</xsl:template>
"@
}

function Compare-XmlComment
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlComment] $ReferenceComment,
	[Parameter(Position=1,Mandatory=$true)][XmlComment] $DifferenceComment
	)
	if($ReferenceComment.Value -ceq $DifferenceComment.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-XPath.ps1 $ReferenceComment)" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:comment><![CDATA[$($DifferenceComment.Value)">]]></xsl:comment>
</xsl:template>
"@
}

function Compare-XmlDocument
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
		Compare-XmlNodes $refpre $diffpre
	}
	#TODO: if ref and diff have no similarities, maybe just modify diff into a simplified stylesheet
	# https://www.w3.org/TR/1999/REC-xslt-19991116#result-element-stylesheet
	Compare-XmlElement $ReferenceDocument.DocumentElement $DifferenceDocument.DocumentElement
	if($ReferenceDocument.DocumentElement.NextSibling -or $DifferenceDocument.DocumentElement.NextSibling)
	{
		$refpost = for($node = $ReferenceDocument.DocumentElement.NextSibling; $node; $node = $node.NextSibling) {$node}
		$diffpost = for($node = $DifferenceDocument.DocumentElement.NextSibling; $node; $node = $node.NextSibling) {$node}
		Compare-XmlNodes $refpost $diffpost
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
	return "<xsl:attribute name='$Name' $(Add-XmlNamespace $Prefix $NamespaceURI)><![CDATA[$Value]]></xsl:attribute>"
}

function Compare-XmlElement
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
			else {Compare-XmlAttribute $ReferenceElement.GetAttributeNode(${@}.LocalName,${@}.NamespaceURI) ${@}}
		}
		else
		{
			if(!$ReferenceElement.HasAttribute(${@}.Name)) {${+} += ${@}}
			else {Compare-XmlAttribute $ReferenceElement.GetAttributeNode(${@}.Name) ${@}}
		}
	}
	foreach(${@} in $ReferenceElement.Attributes)
	{
		if(!${@}.NamespaceURI) {if(!$DifferenceElement.HasAttribute(${@}.LocalName)) {Compare-XmlAttribute ${@} $null}}
		elseif(!$DifferenceElement.HasAttribute(${@}.LocalName,${@}.NamespaceURI)) {Compare-XmlAttribute ${@} $null}
	}
	if(${+})
	{
		[xml]@"
<xsl:template match="$(Resolve-XPath.ps1 $ReferenceElement)"
	$($DifferenceAttribute |Add-XmlNamespace) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:copy>
		$(${+} |Add-XmlAttribute)
		<xsl:apply-templates select="@*|node()" />
	</xsl:copy>
</xsl:template>
"@
	}
	Compare-XmlNodes $ReferenceElement.ChildNodes $DifferenceElement.ChildNodes
}

function Compare-XmlProcessingInstruction
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlProcessingInstruction] $ReferenceProcessingInstruction,
	[Parameter(Position=1,Mandatory=$true)][XmlProcessingInstruction] $DifferenceProcessingInstruction
	)
	if($ReferenceComment.Value -ceq $DifferenceComment.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-XPath.ps1 $ReferenceProcessingInstruction)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:processing-instruction name="$($DifferenceProcessingInstruction.Name)">
		<![CDATA[$($DifferenceProcessingInstruction.Value)">]]>
	</xsl:processing-instruction>
</xsl:template>
"@
}

function Compare-XmlSignificantWhitespace
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlSignificantWhitespace] $ReferenceSignificantWhitespace,
	[Parameter(Position=1,Mandatory=$true)][XmlSignificantWhitespace] $DifferenceSignificantWhitespace
	)
	if($ReferenceSignificantWhitespace.Value -ceq $DifferenceSignificantWhitespace.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-XPath.ps1 $ReferenceSignificantWhitespace)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:text><![CDATA[$($DifferenceSignificantWhitespace.Value)">]]></xsl:text>
</xsl:template>
"@
}

function Compare-XmlText
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlText] $ReferenceText,
	[Parameter(Position=1,Mandatory=$true)][XmlText] $DifferenceText
	)
	if($ReferenceText.Value -ceq $DifferenceText.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-XPath.ps1 $ReferenceText)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:text><![CDATA[$($DifferenceText.Value)">]]></xsl:text>
</xsl:template>
"@
}

function Compare-XmlWhitespace
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlWhitespace] $ReferenceWhitespace,
	[Parameter(Position=1,Mandatory=$true)][XmlWhitespace] $DifferenceWhitespace
	)
	if($ReferenceWhitespace.Value -ceq $DifferenceWhitespace.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-XPath.ps1 $ReferenceWhitespace)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:text>$($DifferenceWhitespace.Value)"></xsl:text>
</xsl:template>
"@
}
function Compare-XmlNode
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlNode] $ReferenceNode,
	[Parameter(Position=1,Mandatory=$true)][XmlNode] $DifferenceNode
	)
	#TODO: Handle nulls? (diff only?)
	if($RefenenceNode.OuterXml -ceq $DifferenceNode.OuterXml) {return}
	switch($DifferenceNode.NodeType)
	{
		Attribute {Compare-XmlAttribute $ReferenceNode $DifferenceNode}
		CDATA {Compare-XmlCData $ReferenceNode $DifferenceNode}
		Comment {Compare-XmlComment $ReferenceNode $DifferenceNode}
		Document {Compare-XmlDocument $ReferenceNode $DifferenceNode}
		Element {Compare-XmlElement $ReferenceNode $DifferenceNode}
		ProcessingInstruction {Compare-XmlProcessingInstruction $ReferenceNode $DifferenceNode}
		SignificantWhitespace {Compare-XmlSignificantWhitespace $ReferenceNode $DifferenceNode}
		Text {Compare-XmlText $ReferenceNode $DifferenceNode}
		Whitespace {Compare-XmlWhitespace $ReferenceNode $DifferenceNode}
		default {return}
	}
}

function Compare-XmlNodes
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][AllowEmptyCollection()][XmlNode[]] $ReferenceNodes,
	[Parameter(Position=1,Mandatory=$true)][AllowEmptyCollection()][XmlNode[]] $DifferenceNodes
	)
	#TODO: Longest common subsequence
}

[xml]$value = @'
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
</xsl:transform>
'@
foreach($template in Compare-XmlNode $ReferenceXml $DifferenceXml)
{
	$template.DocumentElement.RemoveAttribute('xmlns:xsl')
	[void]$value.DocumentElement.AppendChild($value.ImportNode([XmlNode]$template.DocumentElement,$true))
}
$value
