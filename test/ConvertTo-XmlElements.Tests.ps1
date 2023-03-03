<#
.SYNOPSIS
Tests serializing complex content into XML elements.
#>

Describe 'ConvertTo-XmlElements' -Tag ConvertTo-XmlElements {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Serializes complex content into XML elements' -Tag Convert,ConvertTo,ConvertToXmlElements,XML {
		It "Convert '<InputObject>' to '<Result>'" -TestCases @(
			@{ InputObject = @{html=@{body=@{p='Some text.'}}}
				SkipRoot = $true
				Result = '<html><body><p>Some text.</p></body></html>' }
			@{ InputObject = [pscustomobject]@{UserName='username';Computer='COMPUTERNAME'}
				SkipRoot = $false
				Result = "<PSCustomObject>`r`n<UserName>username</UserName>`r`n" +
					"<Computer>COMPUTERNAME</Computer>`r`n</PSCustomObject>" }
			@{ InputObject = '{"item": {"name": "Test", "id": 1 } }' |ConvertFrom-Json
				SkipRoot = $true
				Result = "<item><name>Test</name>`r`n<id>1</id></item>" }
		) {
			Param([psobject] $InputObject, [bool] $SkipRoot, [psobject] $Result)
			ConvertTo-XmlElements.ps1 $InputObject -SkipRoot:$SkipRoot |
				Should -BeExactly $Result -Because 'parameter should work'
			$InputObject |ConvertTo-XmlElements.ps1 -SkipRoot:$SkipRoot |
				Should -BeExactly $Result -Because 'pipeline should work'
		}
	}
}
