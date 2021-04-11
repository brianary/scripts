---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Compare-Xml.ps1

## SYNOPSIS
Compares two XML documents and returns the differences.

## SYNTAX

```
Compare-Xml.ps1 [-ReferenceXml] <XmlDocument> [-DifferenceXml] <XmlDocument> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
' '<a b="y"/>' |Format-Xml.ps1
```

\<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\>
	\<xsl:output omit-xml-declaration="yes" method="xml" /\>
	\<xsl:template match="@*|node()"\>
		\<xsl:copy\>
			\<xsl:apply-templates select="@*|node()" /\>
		\</xsl:copy\>
	\</xsl:template\>
	\<xsl:template match="/a/@b"\>
		\<xsl:attribute name="b"\>\<!\[CDATA\[y\]\]\>\</xsl:attribute\>
	\</xsl:template\>
\</xsl:transform\>

### EXAMPLE 2
```
' '<a c="y"/>' |Format-Xml.ps1
```

\<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\>
	\<xsl:output omit-xml-declaration="yes" method="xml" /\>
	\<xsl:template match="@*|node()"\>
		\<xsl:copy\>
			\<xsl:apply-templates select="@*|node()" /\>
		\</xsl:copy\>
	\</xsl:template\>
	\<xsl:template match="/a/@b" /\>
	\<xsl:template match="/a"\>
		\<xsl:copy\>
			\<xsl:apply-templates select="@*" /\>
			\<xsl:attribute name="c"\>\<!\[CDATA\[y\]\]\>\</xsl:attribute\>
		\</xsl:copy\>
	\</xsl:template\>
\</xsl:transform\>

### EXAMPLE 3
```
<b/><c/><!-- d --></a>' '<a><c/><b/></a>' |Format-Xml.ps1
```

\<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\>
	\<xsl:template match="@*|node()"\>
		\<xsl:copy\>
		\<xsl:apply-templates select="@*|node()" /\>
		\</xsl:copy\>
	\</xsl:template\>
	\<xsl:template match="/a"\>
		\<xsl:copy\>
		\<xsl:apply-templates select="@*" /\>
		\<xsl:apply-templates select="c" /\>
		\<xsl:apply-templates select="b" /\>
		\</xsl:copy\>
	\</xsl:template\>
\</xsl:transform\>

### EXAMPLE 4
```
' '<a><!-- annotation --><new/><?node details?></a>' |Format-Xml.ps1
```

\<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"\>
	\<xsl:template match="@*|node()"\>
		\<xsl:copy\>
			\<xsl:apply-templates select="@*|node()" /\>
		\</xsl:copy\>
	\</xsl:template\>
	\<xsl:template match="/a"\>
		\<xsl:copy\>
			\<xsl:comment\>\<!\[CDATA\[ annotation \]\]\>\</xsl:comment\>
			\<new /\>
			\<xsl:processing-instruction name="node"\>\<!\[CDATA\[details\]\]\>\</xsl:processing-instruction\>
		\</xsl:copy\>
	\</xsl:template\>
\</xsl:transform\>

## PARAMETERS

### -ReferenceXml
The original XML document to be compared.

```yaml
Type: XmlDocument
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DifferenceXml
An XML document to compare to.

```yaml
Type: XmlDocument
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Xml.XmlDocument to compare to the reference XML.
## OUTPUTS

### System.Xml.XmlDocument containing XSLT that can be applied to the reference XML to
### transform it to the difference XML. It contains templates for changed nodes.
## NOTES

## RELATED LINKS

[Resolve-XPath.ps1]()

