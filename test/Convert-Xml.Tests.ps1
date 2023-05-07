<#
.SYNOPSIS
Tests transforming XML using an XSLT template.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Convert-Xml' -Tag Convert-Xml -Skip:$skip {
	BeforeAll {
		if(!(Get-Module -List SelectXmlExtensions)) {Install-Module SelectXmlExtensions -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$datadir = Join-Path $PSScriptRoot .. 'test','data'
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Transform XML using an XSLT template' -Tag ConvertXml,Convert,Xml,Xslt {
		It "Should perform a trivial transform to pipeline data" {
			Convert-Xml.ps1 '<a xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"/>' '<z/>' |
				Format-Xml.ps1 |
				Should -BeExactly '<a />'
		}
		It "Should perform a simple transform to pipeline data" {
			Convert-Xml.ps1 `
				-TransformXslt @"
<a xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
href="{/link/@href}"><xsl:value-of select="/link/@title"/></a>
"@ `
				-Xml '<link title="Example" href="https://example.com/" />' |
				Format-Xml.ps1 |
				Should -BeExactly '<a href="https://example.com/">Example</a>'
		}
		It "Should perform a text transform to a file" {
			$outfile = Join-Path $env:temp temp.txt
			Convert-Xml.ps1 `
				-TransformFile (Join-Path $datadir xslt-test.xslt) `
				-Path (Join-Path $datadir xslt-test.xml) `
				-OutFile $outfile
			$outfile |Should -Exist
			$outfile |Should -FileContentMatchMultilineExactly (Get-Content (Join-Path $datadir xslt-test.txt) -Raw)
			Remove-Item $outfile -Force
		}
	}
}

