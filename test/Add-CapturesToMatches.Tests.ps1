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
	Context 'Add to regex selection' -Tag AddCapturesToMatches,Add,Captures,Xml {
		It "Value '<Text>' should add '<Name>' and '<Email>'" -TestCases @(
			@{ Text = 'Arthur Dent adent@example.org'; Name = 'Arthur Dent'; Email = 'adent@example.org' }
			@{ Text = 'Tricia McMillan trillian@example.com'; Name = 'Tricia McMillan'; Email = 'trillian@example.com' }
		 ) {
			Param([string]$Text,[string]$Name,[string]$Email)
			$result = $Text |Select-String '^(?<Name>.*?\b)\s*(?<Email>\S+@\S+)$' |Add-CapturesToMatches.ps1
			$result.Name |Should -BeExactly $Name -Because 'the name capture should be added'
			$result.Email |Should -BeExactly $Email -Because 'the email capture should be added'
		}
	}
}
