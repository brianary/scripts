<?xml version="1.0"?>
<!--
An XSLT stylesheet to convert WSDL or XSD files to HTML quick-references

This transform requires an XSLT version 2.0 processor (such as Saxon), and uses dataref.css for style.

This stylesheet builds a list of all of the services, ports, and messages (for WSDL), global definitions
(for XSD), data structures and an index of simple fields (for both).
-->
<xsl:transform xmlns="http://www.w3.org/1999/xhtml"
	xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
	xmlns:x="urn:guid:f203a737-cebb-419d-9fbe-a684f1f13591"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0" exclude-result-prefixes="xsl xs x wsdl">
<xsl:output method="html" version="5" use-character-maps="amp"
	encoding="utf-8" media-type=" text/html" indent="yes" />
<xsl:character-map name="amp"><xsl:output-character character="`" string="&amp;" /></xsl:character-map>
<xsl:strip-space elements="*"/>

<xsl:variable name="schema" select="//xs:schema[1]" as="element(xs:schema)"/>
<xsl:variable name="tns" select="$schema/@targetNamespace" as="xs:anyURI?"/>
<xsl:variable name="xs" select="'http://www.w3.org/2001/XMLSchema'" as="xs:string"/>

<xsl:function name="x:in-xs" as="xs:boolean">
	<xsl:param name="QName" as="xs:QName"/>
	<xsl:sequence select="namespace-uri-from-QName($QName) eq $xs"/>
</xsl:function>

<xsl:function name="x:ref-or-self">
	<xsl:param name="item" as="element()"/>
	<xsl:variable name="name" select="local-name($item)" as="xs:string"/>
	<xsl:variable name="ref" select="if ($item/self::xs:*/@ref) then resolve-QName($item/@ref,$item) else ()" as="xs:QName?"/>
	<xsl:sequence select="if (exists($ref)) then $schema/xs:*[local-name() eq $name and QName($tns,@name) eq $ref] else $item"/>
</xsl:function>

<xsl:function name="x:schema-QNames">
	<xsl:param name="elements" as="element()*"/>
	<xsl:sequence select="for $x in $elements return QName($tns,x:ref-or-self($x)/@name)"/>
</xsl:function>

<xsl:function name="x:all-types" as="xs:QName*">
	<xsl:param name="type" as="xs:QName*"/>
	<xsl:if test="exists($type)">
		<xsl:variable name="more" select="x:schema-QNames($schema/xs:*[.//xs:*[@type and resolve-QName(@type,.) = $type]])" as="xs:QName*"/>
		<xsl:sequence select="distinct-values(($type, x:all-types($more)))"/>
	</xsl:if>
</xsl:function>

<xsl:template match="/xs:schema">
	<xsl:variable name="id" select="(@id,@targetNamespace,document-uri(/))[1]"/>
	<xsl:variable name="name" select="if (matches($id,'\p{L}+\.xsd$','i'))
		then replace($id,'^.*?\P{L}*(\p{L}+)\.xsd$','$1','i') else $id" as="xs:string?"/>
	<html><head><title><xsl:value-of select="$name"/> Schema Reference</title>
	<link rel="Stylesheet" type="text/css" href="dataref.css"/>
	</head><body><h1><xsl:value-of select="$name"/> Schema Reference</h1>
	<xsl:for-each select="document-uri(/),@id,@targetNamespace"><div><xsl:value-of select="."/></div></xsl:for-each>
	<xsl:if test="xs:import">
		<h2>Imports</h2>
		<ul>
			<xsl:for-each select="xs:import">
				<li>{<xsl:value-of select="@namespace"/>} <xsl:value-of select="@schemaLocation"/></li>
			</xsl:for-each>
		</ul>
	</xsl:if>
	<xsl:for-each select="xs:simpleType">
		<h2 class="{@name}"><xsl:value-of select="@name"/></h2>
		<xsl:apply-templates select="xs:attribute,* except xs:attribute"/>
	</xsl:for-each>
	<xsl:for-each select="xs:complexType">
		<h2 class="{@name}"><xsl:value-of select="@name"/></h2>
		<table class="{@name}"><caption><xsl:value-of select="@name"/></caption>
			<thead><tr><th>Name</th><th title="Occurrances" class="occurs">#</th>
				<th>Type</th><th class="notes" title="Notes">📝</th></tr></thead>
			<tbody><xsl:apply-templates select="xs:attribute,* except xs:attribute"/></tbody>
		</table>
	</xsl:for-each>
	</body></html>
</xsl:template>

<xsl:template match="wsdl:definitions">
	<html><head><title><xsl:value-of select="wsdl:service/@name" separator=", "/> Reference</title>
	<link rel="Stylesheet" type="text/css" href="dataref.css"/>
	</head><body>
	<xsl:apply-templates select="wsdl:service">
		<xsl:sort select="@name"/>
	</xsl:apply-templates>
	<h1 class="index">Simple Field Index</h1>
	<div class="index">
	<!-- get a list of all of the simple fields by looking for things in the XML Schema namespace -->
	<xsl:for-each-group select="$schema//*[@name and @type and x:in-xs(resolve-QName(@type,.))]" group-by="QName($xs,@type)">
		<xsl:sort select="local-name-from-QName(current-grouping-key())"/>
		<h2><xsl:value-of select="local-name-from-QName(current-grouping-key())"/></h2>
		<ul class="typefields">
			<!-- for each distinct field name of that type -->
			<xsl:for-each-group select="current-group()" group-by="@name">
				<xsl:sort select="current-grouping-key()"/>
				<!-- get the global definition each field occurs in, directly or indirectly -->
				<xsl:variable name="type" as="xs:QName*"
					select="x:all-types(x:schema-QNames(current-group()/ancestor::xs:*[parent::xs:schema] except $schema/xs:element))"/>
				<!-- all elements that use these types -->
				<xsl:variable name="element" as="xs:QName*" select="x:schema-QNames(current-group()/ancestor::xs:element[parent::xs:schema]
					|$schema//xs:element[@type and QName($tns,@type) = $type]/ancestor-or-self::xs:element[parent::xs:schema])"/>
				<!-- all messages that use the group of types and elements associated with these field names -->
				<xsl:variable name="message" as="xs:QName*" select="x:schema-QNames(/wsdl:definitions/wsdl:message
					[wsdl:part[@element and resolve-QName(@element,.) = $element] or wsdl:part[@type and resolve-QName(@type,.) = $type]])"/>
				<li><div><xsl:value-of select="current-grouping-key()"/></div>
				<ul class="fieldops">
					<xsl:for-each-group select="/wsdl:definitions/wsdl:portType/wsdl:operation[wsdl:input[resolve-QName(@message,.) = $message]]" group-by="@name">
						<xsl:sort select="current-grouping-key()"/>
						<li><xsl:text disable-output-escaping="yes">&amp;rarr;</xsl:text>
							<a href="#o.{current-grouping-key()}"><xsl:value-of select="current-grouping-key()"/></a></li>
					</xsl:for-each-group>
					<xsl:for-each-group select="/wsdl:definitions/wsdl:portType/wsdl:operation[wsdl:output[resolve-QName(@message,.) = $message]]" group-by="@name">
						<xsl:sort select="current-grouping-key()"/>
						<li><xsl:text disable-output-escaping="yes">&amp;larr;</xsl:text>
							<a href="#o.{current-grouping-key()}"><xsl:value-of select="current-grouping-key()"/></a></li>
					</xsl:for-each-group>
				</ul></li>
			</xsl:for-each-group>
		</ul>
	</xsl:for-each-group>
	</div></body></html>
</xsl:template>

<xsl:template match="wsdl:documentation|xs:documentation">
	<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="wsdl:service">
	<h1 id="s.{@name}"><xsl:value-of select="@name"/> Reference</h1>
	<xsl:apply-templates select="wsdl:documentation"/>
	<xsl:apply-templates select="/wsdl:definitions/wsdl:portType[@name = current()/wsdl:port/@name]">
		<xsl:sort select="@name"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template match="wsdl:portType">
	<div id="p.{@name}" class="port">
		<h2><xsl:value-of select="@name"/></h2>
		<xsl:apply-templates select="wsdl:documentation"/>
		<xsl:apply-templates select="wsdl:operation">
			<xsl:sort select="@name"/>
		</xsl:apply-templates>
	</div>
</xsl:template>

<xsl:template match="wsdl:operation">
	<div id="o.{@name}" class="operation">
		<h3><xsl:value-of select="@name"/></h3>
		<xsl:apply-templates select="wsdl:documentation,wsdl:input,wsdl:output"/>
	</div>
</xsl:template>

<xsl:template match="wsdl:input|wsdl:output">
	<xsl:variable name="name" select="local-name()" as="xs:string"/>
	<xsl:variable name="message" select="resolve-QName(@message,.)" as="xs:QName"/>
	<xsl:variable name="part" select="/wsdl:definitions/wsdl:message[QName(/wsdl:definitions/@targetNamespace,@name) eq $message]/wsdl:part" as="element(wsdl:part)*"/>
	<xsl:if test="$part">
		<table class="{$name}"><caption><xsl:value-of select="$name"/></caption>
			<thead><tr><th>Name</th><th title="Occurrances" class="occurs">#</th>
				<th>Type</th><th class="notes" title="Notes">📝</th></tr></thead>
			<xsl:apply-templates select="$part"/>
		</table>
	</xsl:if>
</xsl:template>

<xsl:template match="wsdl:part">
	<xsl:variable name="type" select="if (@type) then resolve-QName(@type,.) else ()" as="xs:QName?"/>
	<xsl:choose>
		<xsl:when test="exists($type)">
			<xsl:variable name="complexType" select="$schema/xs:complexType[QName($tns,@name) eq $type]" as="element(xs:complexType)?"/>
			<xsl:choose>
				<xsl:when test="x:in-xs($type)">
					<tbody><tr><td><xsl:value-of select="@name"/></td><td class="occurs"/>
						<td><xsl:value-of select="local-name-from-QName($type)"/></td></tr></tbody>
				</xsl:when>
				<xsl:when test="not(exists($complexType))">
					<tbody><tr><td><xsl:value-of select="@name"/></td><td class="occurs"/>
						<td><xsl:value-of select="@type"/></td></tr></tbody>
				</xsl:when>
				<xsl:otherwise>
					<tbody><xsl:apply-templates select="$complexType"/></tbody>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<xsl:variable name="element" select="resolve-QName(@element,.)" as="xs:QName"/>
			<tbody><xsl:apply-templates select="$schema/xs:element[QName($tns,@name) eq $element]"/></tbody>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="xs:element[@ref]|xs:attribute[@ref]|xs:group[@ref]">
	<xsl:apply-templates select="x:ref-or-self(.)"/>
</xsl:template>

<xsl:template match="xs:element|xs:attribute">
	<xsl:param name="depth" select="0" as="xs:integer" tunnel="yes"/>
	<xsl:variable name="name" select="if (self::xs:attribute) then concat('@',@name) else @name" as="xs:string?"/>
	<xsl:variable name="type" select="if (@type) then resolve-QName(@type,.) else ()" as="xs:QName?"/>
	<xsl:variable name="complexType" select="if (xs:complexType) then xs:complexType
		else if (exists($type)) then $schema/xs:complexType[QName($tns,@name) eq $type] else ()" as="element()*"/>
	<xsl:choose>
		<xsl:when test="not(@type) and not(exists(xs:simpleType|xs:complexType))">
			<tr><td style="padding-left:{$depth}em"><xsl:value-of select="$name"/></td>
				<td class="occurs"><xsl:call-template name="occurs"/></td>
				<td><var>ANY</var></td>
				<td class="notes"><xsl:if test="xs:annotation"><details><summary>📝</summary>
					<xsl:apply-templates select="xs:annotation"/></details></xsl:if></td></tr>
		</xsl:when>
		<xsl:when test="xs:simpleType">
			<tr><td style="padding-left:{$depth}em"><xsl:value-of select="$name"/></td>
				<td class="occurs"><xsl:call-template name="occurs"/></td>
				<td><xsl:apply-templates select="xs:simpleType"/></td>
				<td class="notes"><xsl:if test="xs:annotation"><details><summary>📝</summary>
					<xsl:apply-templates select="xs:annotation"/></details></xsl:if></td></tr>
		</xsl:when>
		<xsl:when test="not(exists($complexType))">
			<xsl:variable name="element" select="if (@element) then resolve-QName(@element,.) else ()" as="xs:QName?"/>
			<tr><td style="padding-left:{$depth}em"><xsl:value-of select="$name"/></td>
				<td class="occurs"><xsl:call-template name="occurs"/></td>
				<td><xsl:value-of select="@type"/>
					<xsl:apply-templates select="xs:attribute,$schema/xs:simpleType[not(exists($type)) or QName($tns,@name) eq $type]"/>
				</td>
				<td class="notes"><xsl:if test="xs:annotation"><details><summary>📝</summary>
					<xsl:apply-templates select="xs:annotation"/></details></xsl:if></td></tr>
			<xsl:apply-templates select="$schema/xs:element[QName($tns,@name) = $element]">
				<xsl:with-param name="depth" select="$depth +1" as="xs:integer" tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:when test="exists($type) and x:in-xs($type)">
			<tr><td style="padding-left:{$depth}em"><xsl:value-of select="$name"/></td>
				<td class="occurs"><xsl:call-template name="occurs"/></td>
				<td><xsl:value-of select="local-name-from-QName($type)"/></td>
				<td class="notes"><xsl:if test="xs:annotation"><details><summary>📝</summary>
					<xsl:apply-templates select="xs:annotation"/></details></xsl:if></td></tr>
		</xsl:when>
		<xsl:otherwise>
			<tr><th style="padding-left:{$depth}em"><xsl:value-of select="$name"/></th>
				<td class="occurs"><xsl:call-template name="occurs"/></td>
				<td><xsl:value-of select="($type,@name)[1]"/></td>
				<td class="notes"><xsl:if test="xs:annotation"><details><summary>📝</summary>
					<xsl:apply-templates select="xs:annotation"/></details></xsl:if></td></tr>
			<xsl:apply-templates select="xs:attribute,$complexType">
				<xsl:with-param name="depth" select="$depth +1" as="xs:integer" tunnel="yes"/>
			</xsl:apply-templates>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="xs:annotation">
	<xsl:apply-templates/>
</xsl:template>

<xsl:template match="xs:any">
	<xsl:param name="depth" select="0" as="xs:integer" tunnel="yes"/>
	<tr><th class="direction" style="padding-left:{$depth}em">(anything)</th>
		<td class="occurs"><xsl:call-template name="occurs"/></td>
		<td><xsl:value-of select="@id"/></td></tr>
</xsl:template>

<xsl:template match="xs:choice">
	<xsl:param name="depth" select="0" as="xs:integer" tunnel="yes"/>
	<tr><th class="direction" style="padding-left:{$depth}em">Choose one:</th>
		<td class="occurs"><xsl:call-template name="occurs"/></td>
		<td><xsl:value-of select="@id"/></td></tr>
	<xsl:apply-templates>
		<xsl:with-param name="depth" select="$depth +1" as="xs:integer" tunnel="yes"/>
	</xsl:apply-templates>
	<tr><th class="direction" style="padding-left:{$depth}em">end choice.</th></tr>
</xsl:template>

<xsl:template match="xs:group[(@minOccurs and @minOccurs ne '1') or (@maxOccurs and @maxOccurs ne '1')]">
	<xsl:param name="depth" select="0" as="xs:integer" tunnel="yes"/>
	<tr><th class="direction" style="padding-left:{$depth}em">Group:</th>
		<td class="occurs"><xsl:call-template name="occurs"/></td>
		<td><xsl:value-of select="@id,@name"/></td></tr>
	<xsl:apply-templates>
		<xsl:with-param name="depth" select="$depth +1" as="xs:integer" tunnel="yes"/>
	</xsl:apply-templates>
	<tr><th class="direction" style="padding-left:{$depth}em">end group.</th></tr>
</xsl:template>

<xsl:template match="xs:sequence[(@minOccurs and @minOccurs ne '1') or (@maxOccurs and @maxOccurs ne '1')]">
	<xsl:param name="depth" select="0" as="xs:integer" tunnel="yes"/>
	<tr><th class="direction" style="padding-left:{$depth}em">Choose one:</th>
		<td class="occurs"><xsl:call-template name="occurs"/></td>
		<td><xsl:value-of select="@id"/></td></tr>
	<xsl:apply-templates>
		<xsl:with-param name="depth" select="$depth +1" as="xs:integer" tunnel="yes"/>
	</xsl:apply-templates>
	<tr><th class="direction" style="padding-left:{$depth}em">end choice.</th></tr>
</xsl:template>

<xsl:template name="occurs">
	<xsl:variable name="min" select="(@minOccurs,'1')[1]" as="xs:string"/>
	<xsl:variable name="max" select="(@maxOccurs,'1')[1]" as="xs:string"/>
	<xsl:choose>
		<xsl:when test="self::xs:attribute and @use ne 'required'">?</xsl:when>
		<xsl:when test="$min eq '1' and $max eq '1'"/>
		<xsl:when test="$min eq '0' and $max eq '1'">?</xsl:when>
		<xsl:when test="$min eq '0' and $max eq 'unbounded'">*</xsl:when>
		<xsl:when test="$min eq '1' and $max eq 'unbounded'">+</xsl:when>
		<xsl:when test="$min eq $max">{<xsl:value-of select="$min"/>}</xsl:when>
		<xsl:when test="$max eq 'unbounded'">{<xsl:value-of select="$min"/>,}</xsl:when>
		<xsl:otherwise>{<xsl:value-of select="$min"/>,<xsl:value-of select="$max"/>}</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="xs:restriction">
	<xsl:if test="not(xs:enumeration) and @base">
		<xsl:choose>
			<xsl:when test="not(* except xs:annotation)"><xsl:value-of select="@base" /></xsl:when>
			<xsl:otherwise><p>A <code><xsl:value-of select="@base" /></code>, with the following restrictions:</p></xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<ul><xsl:if test="xs:enumeration and not(* except xs:enumeration)">
			<xsl:attribute name="style">
				<xsl:text>columns:</xsl:text>
				<xsl:value-of select="max(for $enum in xs:enumeration/@value return string-length($enum))"/>
				<xsl:text>em</xsl:text>
			</xsl:attribute>
		</xsl:if>
		<xsl:apply-templates /></ul>
</xsl:template>

<xsl:template match="xs:minExclusive">
	<li>`gt; <xsl:value-of select="@value"/></li>
</xsl:template>

<xsl:template match="xs:minInclusive">
	<li>`ge; <xsl:value-of select="@value"/></li>
</xsl:template>

<xsl:template match="xs:maxExclusive">
	<li>`lt; <xsl:value-of select="@value"/></li>
</xsl:template>

<xsl:template match="xs:maxInclusive">
	<li>`le; <xsl:value-of select="@value"/></li>
</xsl:template>

<xsl:template match="xs:minLength">
	<li>length `ge; <xsl:value-of select="@value"/></li>
</xsl:template>

<xsl:template match="xs:maxLength">
	<li>length `le; <xsl:value-of select="@value"/></li>
</xsl:template>

<xsl:template match="xs:length">
	<li>length = <xsl:value-of select="@value"/></li>
</xsl:template>

<xsl:template match="xs:totalDigits">
	<li><xsl:value-of select="@value"/> total digits</li>
</xsl:template>

<xsl:template match="xs:fractionDigits">
	<li><xsl:value-of select="@value"/> digits following the decimal</li>
</xsl:template>

<xsl:template match="xs:whiteSpace">
	<li><xsl:value-of select="@value"/> all whitespace</li>
</xsl:template>

<xsl:template match="xs:pattern">
	<li>matches: <code><xsl:value-of select="@value"/></code></li>
</xsl:template>

<xsl:template match="xs:enumeration[not(@value) or @value='']">
	<li class="space">
		<xsl:if test="not(xs:annotation/xs:documentation)"><xsl:attribute name="title">(empty string)</xsl:attribute></xsl:if>
		<xsl:apply-templates select="xs:annotation/xs:documentation"/>
		<xsl:text>&#x2422;</xsl:text></li>
</xsl:template>

<xsl:template match="xs:enumeration[matches(@value,'^\s+$')]">
	<li class="space"><xsl:apply-templates select="xs:annotation/xs:documentation"/>
		<xsl:value-of select="replace(@value,' ','&#x2423;')"/></li>
</xsl:template>

<xsl:template match="xs:enumeration">
	<li><xsl:apply-templates select="xs:annotation/xs:documentation"/>
		<xsl:value-of select="@value"/></li>
</xsl:template>

<xsl:template match="xs:enumeration/xs:annotation/xs:documentation">
	<xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>

</xsl:transform>
