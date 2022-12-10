<#
.SYNOPSIS
Tests adding named capture group values as note properties to Select-String MatchInfo objects.
#>

Describe 'Add-CapturesToMatches' -Tag Add-CapturesToMatches,Select-Xml {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Add-CapturesToMatches.ps1
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
	Context 'Add to regex selection' {
		It "Value '<Text>' should add '<Name>' and '<Email>'" -TestCases @(
			@{ Text = 'Arthur Dent adent@example.org'; Name = 'Arthur Dent'; Email = 'adent@example.org' }
			@{ Text = 'Tricia McMillan trillian@example.com'; Name = 'Tricia McMillan'; Email = 'trillian@example.com' }
		 ) {
			Param([string]$Text,[string]$Name,[string]$Email)
			$result = $Text |Select-String '^(?<Name>.*?\b)\s*(?<Email>\S+@\S+)$' |Add-CapturesToMatches.ps1
			$result.Name |Should -BeExactly $Name
			$result.Email |Should -BeExactly $Email
		}
	}
}
