<#
.Synopsis
	Compares two XML documents and returns the differences.

.Example
	Compare-Xml.ps1 '<a b="z"/>' '<a b="y"/>' |Format-Xml.ps1

	<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
		<xsl:template match="@*|node()">
			<xsl:copy>
				<xsl:apply-templates select="@*|node()" />
			</xsl:copy>
		</xsl:template>
		<xsl:template match="/a/@b" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<xsl:attribute name="b"><![CDATA[y]]></xsl:attribute>
		</xsl:template>
	</xsl:transform>
#>

#Requires -Version 3
using namespace System.Xml
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][xml] $ReferenceXml,
[Parameter(Position=1,Mandatory=$true)][xml] $DifferenceXml
)

function Compare-XmlAttribute
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlAttribute] $ReferenceAttribute,
	[Parameter(Position=1,Mandatory=$true)][XmlAttribute] $DifferenceAttribute
	)
	if($ReferenceAttribute.LocalName -eq $DifferenceAttribute.LocalName -and
		$ReferenceAttribute.NamespaceURI -eq $DifferenceAttribute.NamespaceURI -and
		$ReferenceAttribute.Value -eq $DifferenceAttribute.Value) {return}
	$ns = if($DifferenceAttribute.Prefix) {"xmlns:$($DifferenceAttribute.Prefix)='$($DifferenceAttribute.NamespaceURI)' "}
	return [xml]@"
<xsl:template match="$(Resolve-Xml.ps1 $ReferenceAttribute)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	if($ReferenceCData.Value -eq $DifferenceCData.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-Xml.ps1 $ReferenceCData)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	if($ReferenceComment.Value -eq $DifferenceComment.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-Xml.ps1 $ReferenceComment)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	#TODO: <xsl:output> with method from DocumentType.Name, omit-xml-declaration from FirstChild is XmlDeclaration,
	#      with doctype-public, doctype-system, encoding
	#TODO: (certain) nodes before and after document element, using longest common subsequence
	Compare-XmlElement $ReferenceDocument.DocumentElement $DifferenceDocument.DocumentElement
}

function Compare-XmlElement
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlElement] $ReferenceElement,
	[Parameter(Position=1,Mandatory=$true)][XmlElement] $DifferenceElement
	)
	foreach($att in $ReferenceElement.Attributes)
	{
		if($att.NamespaceURI)
		{
			if($DifferenceElement.HasAttribute($att.LocalName,$att.NamespaceURI))
			{
				Compare-XmlAttribute $att ($DifferenceElement.GetAttributeNode($att.LocalName,$att.NamespaceURI))
			}
			#TODO: else (check namespace for change?) remove attribute
		}
		else
		{
			if($DifferenceElement.HasAttribute($att.LocalName))
			{
				Compare-XmlAttribute $att ($DifferenceElement.GetAttributeNode($att.LocalName))
			}
			#TODO: else remove attribute
		}
	}
	#TODO: compare children using longest common subsequence
}

function Compare-XmlProcessingInstruction
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][XmlProcessingInstruction] $ReferenceProcessingInstruction,
	[Parameter(Position=1,Mandatory=$true)][XmlProcessingInstruction] $DifferenceProcessingInstruction
	)
	if($ReferenceComment.Value -eq $DifferenceComment.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-Xml.ps1 $ReferenceProcessingInstruction)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	if($ReferenceSignificantWhitespace.Value -eq $DifferenceSignificantWhitespace.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-Xml.ps1 $ReferenceSignificantWhitespace)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	if($ReferenceText.Value -eq $DifferenceText.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-Xml.ps1 $ReferenceText)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	if($ReferenceWhitespace.Value -eq $DifferenceWhitespace.Value) {return}
	return [xml]@"
<xsl:template match="$(Resolve-Xml.ps1 $ReferenceWhitespace)" ${ns}xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
	if($RefenenceNode.OuterXml -eq $DifferenceNode.OuterXml) {return}
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

[xml]$value = @'
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="@*|node()"><xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy></xsl:template>
</xsl:transform>
'@
foreach($template in Compare-XmlNode $ReferenceXml $DifferenceXml)
{
	[void]$value.DocumentElement.AppendChild($value.ImportNode([XmlNode]$template.DocumentElement,$true))
}
$value
