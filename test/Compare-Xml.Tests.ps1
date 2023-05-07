<#
.SYNOPSIS
Tests Compares two XML documents and returns the differences.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Compare-Xml' -Tag Compare-Xml -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Compares two XML documents and returns the differences as XSLT' -Tag CompareXml,Compare,Xml {
		It 'Should return a diff that updates an attribute value' {
			Compare-Xml.ps1 '<a b="z"/>' '<a b="y"/>' |Format-Xml.ps1 |Should -BeExactly @"
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/a/@b">
    <xsl:attribute name="b"><![CDATA[y]]></xsl:attribute>
  </xsl:template>
</xsl:transform>
"@
		}
		It 'Should return a diff that changes attributes' {
			Compare-Xml.ps1 '<a b="z"/>' '<a c="y"/>' |Format-Xml.ps1 |Should -BeExactly @"
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/a/@b" />
  <xsl:template match="/a">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:attribute name="c"><![CDATA[y]]></xsl:attribute>
    </xsl:copy>
  </xsl:template>
</xsl:transform>
"@
		}
		It 'Should return a diff that changes child nodes' {
			Compare-Xml.ps1 '<a><b/><c/><!-- d --></a>' '<a><c/><b/></a>' |Format-Xml.ps1 |Should -BeExactly @"
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/a">
    <xsl:copy>
      <xsl:apply-templates select="c" />
      <b />
    </xsl:copy>
  </xsl:template>
</xsl:transform>
"@
		}
		It 'Should return a diff that adds child nodes' {
			Compare-Xml.ps1 '<a/>' '<a><!-- annotation --><new/><?node details?></a>' |Format-Xml.ps1 |Should -BeExactly @"
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/a">
    <xsl:copy>
      <xsl:comment><![CDATA[ annotation ]]></xsl:comment>
      <new />
      <xsl:processing-instruction name="node"><![CDATA[details]]></xsl:processing-instruction>
    </xsl:copy>
  </xsl:template>
</xsl:transform>
"@
		}
	}

}
