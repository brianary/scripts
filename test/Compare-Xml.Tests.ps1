<#
.SYNOPSIS
Tests Compares two XML documents and returns the differences.
#>

Describe 'Compare-Xml' -Tag Compare-Xml {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Compare-Xml.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Warning |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Error |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style errors'
		}
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
