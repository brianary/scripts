<#
.SYNOPSIS
Compares two XML documents and returns the differences.

.INPUTS
System.Xml.XmlDocument to compare to the reference XML.

.OUTPUTS
System.Xml.XmlDocument containing XSLT that can be applied to the reference XML to
transform it to the difference XML. It contains templates for changed nodes.

.LINK
Resolve-XPath.ps1

.EXAMPLE
Compare-Xml.ps1 '<a b="z"/>' '<a b="y"/>' |Format-Xml.ps1

| <xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
|   <xsl:output omit-xml-declaration="yes" method="xml" />
|   <xsl:template match="@*|node()">
|     <xsl:copy>
|       <xsl:apply-templates select="@*|node()" />
|     </xsl:copy>
|   </xsl:template>
|   <xsl:template match="/a/@b">
|     <xsl:attribute name="b"><![CDATA[y]]></xsl:attribute>
|   </xsl:template>
| </xsl:transform>

.EXAMPLE
Compare-Xml.ps1 '<a b="z"/>' '<a c="y"/>' |Format-Xml.ps1

| <xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
|   <xsl:output omit-xml-declaration="yes" method="xml" />
|   <xsl:template match="@*|node()">
|     <xsl:copy>
|       <xsl:apply-templates select="@*|node()" />
|     </xsl:copy>
|   </xsl:template>
|   <xsl:template match="/a/@b" />
|   <xsl:template match="/a">
|     <xsl:copy>
|       <xsl:apply-templates select="@*" />
|       <xsl:attribute name="c"><![CDATA[y]]></xsl:attribute>
|     </xsl:copy>
|   </xsl:template>
| </xsl:transform>

.EXAMPLE
Compare-Xml.ps1 '<a><b/><c/><!-- d --></a>' '<a><c/><b/></a>' |Format-Xml.ps1

| <xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
|   <xsl:template match="@*|node()">
|     <xsl:copy>
|       <xsl:apply-templates select="@*|node()" />
|     </xsl:copy>
|   </xsl:template>
|   <xsl:template match="/a">
|     <xsl:copy>
|       <xsl:apply-templates select="@*" />
|       <xsl:apply-templates select="c" />
|       <xsl:apply-templates select="b" />
|     </xsl:copy>
|   </xsl:template>
| </xsl:transform>

.EXAMPLE
Compare-Xml.ps1 '<a/>' '<a><!-- annotation --><new/><?node details?></a>' |Format-Xml.ps1

| <xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
|   <xsl:template match="@*|node()">
|     <xsl:copy>
|       <xsl:apply-templates select="@*|node()" />
|     </xsl:copy>
|   </xsl:template>
|   <xsl:template match="/a">
|     <xsl:copy>
|       <xsl:comment><![CDATA[ annotation ]]></xsl:comment>
|       <new />
|       <xsl:processing-instruction name="node"><![CDATA[details]]></xsl:processing-instruction>
|     </xsl:copy>
|   </xsl:template>
| </xsl:transform>
#>

#Requires -Version 3
using namespace System.Xml
[CmdletBinding()][OutputType([xml])] Param(
# The original XML document to be compared.
[Parameter(Position=0,Mandatory=$true)][xml] $ReferenceXml,
# An XML document to compare to.
[Parameter(Position=1,Mandatory=$true)][xml] $DifferenceXml
)

function Test-XmlNodesMatch
{
	Param(
	[Parameter(Position=0)][XmlNode] $ReferenceNode,
	[Parameter(Position=1)][XmlNode] $DifferenceNode
	)
	if($null -eq $ReferenceNode) {return}
	elseif($null -eq $DifferenceNode) {return}
	elseif($ReferenceNode.NodeType -ne $DifferenceNode.NodeType) {return}
	elseif($ReferenceNode.NamespaceURI -cne $DifferenceNode.NamespaceURI) {return}
	elseif($ReferenceNode.LocalName -cne $DifferenceNode.LocalName) {return}
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
	elseif(!(Test-XmlNodesMatch $ReferenceNode $DifferenceNode)) {return $false}
	elseif($ReferenceNode.NodeType -eq 'Element' -and
		!(Test-XmlAttributesEqual $ReferenceNode $DifferenceNode)) {return $false}
	elseif($ReferenceNode.ChildNodes.Count -ne $DifferenceNode.ChildNodes.Count) {return $false}
	else
	{
		for($i = 0; $i -lt $ReferenceNode.ChildNodes.Count; $i++)
		{
			if(!(Test-XmlNodesEqual $ReferenceNode.ChildNodes[$i] $DifferenceNode.ChildNodes[$i])) {return $false}
		}
		return $ReferenceNode.Value -ceq $DifferenceNode.Value
	}
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
	<xsl:text><![CDATA[$($DifferenceCData.Value)]]></xsl:text>
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
	<xsl:comment><![CDATA[$($DifferenceComment.Value)]]></xsl:comment>
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
		<![CDATA[$($DifferenceProcessingInstruction.Value)]]>
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
	<xsl:text><![CDATA[$($DifferenceSignificantWhitespace.Value)]]></xsl:text>
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
	<xsl:text><![CDATA[$($DifferenceText.Value)]]></xsl:text>
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

function Measure-XmlNodePosition([Parameter(Position=0,Mandatory=$true)][XmlNode]$Node)
{
	if(!($Node.PreviousSibling -or $Node.NextSibling)) {return}
	for($i,$n = 0,$Node; $n; $n = $n.PreviousSibling) {if(Test-XmlNodesMatch $n $Node) {$i++}}
	if($i -gt 1) {return "[$i]"}
	for($i,$n = 0,$Node.NextSibling; $n; $n = $n.NextSibling) {if(Test-XmlNodesMatch $n $Node) {$i++; break}}
	if($i -gt 0) {return '[1]'}
	else {return}
}

function Format-ApplyTemplates
{
	[CmdletBinding()] Param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][XmlNodeType] $NodeType,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][ValidateNotNullOrEmpty()][string] $Name,
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $LocalName,
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Prefix,
	[Parameter(ValueFromPipelineByPropertyName=$true)][string] $NamespaceURI,
	[Parameter(ValueFromPipeline=$true)][XmlNode] $Node
	)
	$fullname = if($NamespaceURI -and !$Prefix) {$Prefix = 'ns'; "ns:$LocalName"} else {$Name}
	$xpath = switch($NodeType)
	{
		Attribute {"@$fullname"}
		CDATA {"text()$(Measure-XmlNodePosition $Node)"}
		Comment {"comment()$(Measure-XmlNodePosition $Node)"}
		Document {'/'}
		Element {"$fullname$(Measure-XmlNodePosition $Node)"}
		ProcessingInstruction {"processing-instruction('$name')$(Measure-XmlNodePosition $Node)"}
		SignificantWhitespace {"text()$(Measure-XmlNodePosition $Node)"}
		Text {"text()$(Measure-XmlNodePosition $Node)"}
		Whitespace {"text()$(Measure-XmlNodePosition $Node)"}
		default {return}
	}
	if(!$NamespaceURI) {return "<xsl:apply-templates select='$xpath'/>"}
	else {return "<xsl:apply-templates select='$xpath' xmlns:$Prefix='$NamespaceURI'/>"}
}

function ConvertTo-XmlNodeLiteral
{
	[CmdletBinding()] Param([Parameter(Position=0,Mandatory=$true)][XmlNode] $Node)
	$ns = 'xmlns:xsl="http://www.w3.org/1999/XSL/Transform"'
	switch($Node.NodeType)
	{
		CDATA {"<xsl:text><![CDATA[$($Node.Value)]]></xsl:text>"}
		Comment {"<xsl:comment><![CDATA[$($Node.Value)]]></xsl:comment>"}
		Element {$Node.OuterXml}
		ProcessingInstruction {("<{0} name='$($Node.Name)'><![CDATA[$($Node.Value)]]></{0}>" -f
			'xsl:processing-instruction')}
		SignificantWhitespace {"<xsl:text><![CDATA[$($Node.Value)]]></xsl:text>"}
		Text {"<xsl:text><![CDATA[$($Node.Value)]]></xsl:text>"}
		Whitespace {"<xsl:text><![CDATA[$($Node.Value)]]></xsl:text>"}
		default {return}
	}
}

function Merge-XmlNodes
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][AllowEmptyCollection()][XmlNode[]] $ReferenceNodes,
	[Parameter(Position=1,Mandatory=$true)][AllowEmptyCollection()][XmlNode[]] $DifferenceNodes
	)
	for($d,$list = 0,@(); $d -lt $DifferenceNodes.Length; $d++)
	{
		$diff = $DifferenceNodes[$d]
		[int[]] $matches =
			if($ReferenceNodes.Length -le 0) {@()}
			else {0..($ReferenceNodes.Length-1) |where {Test-XmlNodesMatch $ReferenceNodes[$_] $diff}}
		[int] $r =
			if(!$matches -or $matches.Length -eq 0) {-1}
			elseif($matches.Length -eq 1) {$matches[0]}
			else
			{
				$equals = $matches |where {Test-XmlNodesEqual $ReferenceNodes[$_] $diff} |select -First 1
				if($equals.Length -eq 0) {$matches[0]}
				else {$equals[0]}
			}
		$list += [pscustomobject]@{
			ReferenceNode   = if($r -eq -1) {$null} else {$ReferenceNodes[$r]}
			ReferenceIndex  = $r
			DifferenceNode  = $DifferenceNodes[$d]
			DifferenceIndex = $d
			Template        = if($r -eq -1) {$null} else {ConvertTo-XmlNodeTemplates $ReferenceNodes[$r] $diff}
		}
		if($r -ne -1) {$ReferenceNodes[$r] = [xml]'<null/>'}
	}
	return ([pscustomobject]@{
		HasDifferentOrder = !!($list |where {$_.ReferenceIndex -ne $_.DifferenceIndex})
		ApplyTemplates    = ($list |
			foreach {
				if($_.ReferenceNode) {$_.ReferenceNode |Format-ApplyTemplates}
				else {ConvertTo-XmlNodeLiteral $_.DifferenceNode}
			}
		) -join [environment]::NewLine
		Templates         = $list |where Template -ne $null |foreach Template
	})
}

function Add-XmlAttribute
{
	[CmdletBinding()] Param(
	[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][ValidateNotNullOrEmpty()][string] $Name,
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
	$merge = Merge-XmlNodes $ReferenceElement.ChildNodes $DifferenceElement.ChildNodes
	$merge.Templates
	if(${+} -or $merge.HasDifferentOrder)
	{[xml]@"
<xsl:template $(Format-XPathMatch $ReferenceElement) xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:copy>
		$(if($ReferenceElement.HasAttributes) {'<xsl:apply-templates select="@*" />'})
		$(if(${+}) {${+} |Add-XmlAttribute})
		$($merge.ApplyTemplates)
	</xsl:copy>
</xsl:template>
"@}
}

function ConvertTo-XmlDocumentTemplates
{
	Param(
	[Parameter(Position=0,Mandatory=$true)][xml] $ReferenceDocument,
	[Parameter(Position=1,Mandatory=$true)][xml] $DifferenceDocument
	)
	$ns = 'xmlns:xsl="http://www.w3.org/1999/XSL/Transform"'
	$declaration =
		if($DifferenceDocument.FirstChild.NodeType -eq 'XmlDeclaration')
		{
			"omit-xml-declaration='yes'"
			$encoding = $DifferenceDocument.FirstChild.Encoding
			if($encoding) {"encoding='$encoding'"}
			$standalone = $DifferenceDocument.FirstChild.Standalone
			if($standalone) {"standalone='$standalone'"}
		}
	$doctype = $DifferenceDocument.ChildNodes |where NodeType -ceq 'DocumentType'
	if($doctype)
	{
		if($doctype.PublicId -like '-//W3C//DTD XHTML *')
		{[xml]@"
<xsl:output $declaration method="xhtml" doctype-public="$($doctype.PublicId)" doctype-system="$($doctype.SystemId)" $ns />
"@}
		elseif($doctype.name -ceq 'html')
		{[xml]@"
<xsl:output $declaration method="html" doctype-public="$($doctype.PublicId)" doctype-system="$($doctype.SystemId)" $ns />
"@}
		else
		{[xml]@"
<xsl:output $declaration method="xml" doctype-public="$($doctype.PublicId)" doctype-system="$($doctype.SystemId)" $ns />
"@}
	}
	elseif($declaration)
	{[xml]@"
<xsl:output $declaration method="xml" $ns />
"@}
[xml]@"
<xsl:template match="@*|node()" $ns><xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy></xsl:template>
"@
	$reorder = $false
	if($ReferenceDocument.DocumentElement.PreviousSibling -or $DifferenceDocument.DocumentElement.PreviousSibling)
	{
		$refpre = foreach($node in $ReferenceDocument.ChildNodes)
		{
			if($node.NodeType -ceq 'Element') {break}
			elseif($node.NodeType -notin 'XmlDeclaration','DocumentType') {$node}
		}
		if($null -eq $refpre) {$refpre = @()}
		$diffpre = foreach($node in $DifferenceDocument.ChildNodes)
		{
			if($node.NodeType -ceq 'Element') {break}
			elseif($node.NodeType -notin 'XmlDeclaration','DocumentType') {$node}
		}
		if($null -eq $diffpre) {$diffpre = @()}
		$mergepre = Merge-XmlNodes $refpre $diffpre
		$reorder = $mergepre.HasDifferentOrder
		$mergepre.Templates
	}
	ConvertTo-XmlElementTemplates $ReferenceDocument.DocumentElement $DifferenceDocument.DocumentElement
	if($ReferenceDocument.DocumentElement.NextSibling -or $DifferenceDocument.DocumentElement.NextSibling)
	{
		$refpost = for($node = $ReferenceDocument.DocumentElement.NextSibling; $node; $node = $node.NextSibling) {$node}
		if($null -eq $refpost) {$refpost = @()}
		$diffpost = for($node = $DifferenceDocument.DocumentElement.NextSibling; $node; $node = $node.NextSibling) {$node}
		if($null -eq $diffpost) {$diffpost = @()}
		$mergepost = Merge-XmlNodes $refpost $diffpost
		if(!$reorder) {$reorder = $mergepost.HasDifferentOrder}
		$mergepost.Templates
	}
	if($reorder)
	{[xml]@"
<xsl:template match="/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	$($mergepre.ApplyTemplates)
	<xsl:apply-templates select="*"/>
	$($mergepost.ApplyTemplates)
</xsl:template>
"@}
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
	if(Test-XmlNodesEqual $ReferenceNode $DifferenceNode) {return}
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
			if($null -eq $template) {continue}
			$template.DocumentElement.RemoveAttribute('xmlns:xsl')
			[void]$value.DocumentElement.AppendChild($value.ImportNode([XmlNode]$template.DocumentElement,$true))
		}
	}
	return $value
}

Compare-Xml
