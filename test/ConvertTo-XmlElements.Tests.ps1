<#
.SYNOPSIS
Tests Serializes complex content into XML elements.
#>

Describe 'ConvertTo-XmlElements' -Tag ConvertTo-XmlElements {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Serializes complex content into XML elements' -Tag Convert,ConvertTo,ConvertToXmlElements,XML {
		It "Convert '<Value>' to '<Result>'" -TestCases @(
			@{ Value = @{html=@{body=@{p='Some text.'}}}
				Result = '<html><body><p>Some text.</p></body></html>' }
			@{ Value = [pscustomobject]@{UserName='username';Computer='COMPUTERNAME'}
				Result = @('<UserName>username</UserName>','<Computer>COMPUTERNAME</Computer>') }
			@{ Value = '{"item": {"name": "Test", "id": 1 } }' |ConvertFrom-Json
				Result = "<item><name>Test</name>`n<id>1</id></item>" }
		) {
			Param([psobject] $Value, [psobject] $Result)
			ConvertTo-XmlElements.ps1 $Value |Should -BeExactly $Result -Because 'parameter should work'
			$Value |ConvertTo-XmlElements.ps1 |Should -BeExactly $Result -Because 'pipeline should work'
		}
	}
}
