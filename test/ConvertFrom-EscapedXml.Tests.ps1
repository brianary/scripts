<#
.SYNOPSIS
Tests parsing escaped XML into XML and serialization.
#>

Describe 'ConvertFrom-EscapedXml' -Tag ConvertFrom-EscapedXml {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertFrom-EscapedXml.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Parse escaped XML into XML and serialize it' -Tag ConvertFromEscapedXml,Convert,ConvertFrom,EscapedXml,Xml {
		It "Should convert '<Input>' into '<Output>'" -TestCases @(
			@{ Value = '&lt;x /&gt;'; Result = '<x />' }
			@{ Value = '&lt;a href=&quot;http://example.org&quot;&gt;link&lt;/a&gt;'
				Result = '<a href="http://example.org">link</a>' }
		) {
			Param([string]$Value,[string]$Result)
			ConvertFrom-EscapedXml.ps1 $Value |Should -BeExactly $Result -Because 'input parameter should work'
			$Value |ConvertFrom-EscapedXml.ps1 |Should -BeExactly $Result -Because 'input pipeline should work'
		}
	}

}
