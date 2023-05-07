<#
.SYNOPSIS
Tests parsing escaped XML into XML and serialization.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertFrom-EscapedXml' -Tag ConvertFrom-EscapedXml -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
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

