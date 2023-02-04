<#
.SYNOPSIS
Tests adding an incrementing integer property to each pipeline object.
#>

Describe 'Add-Counter' -Tag Add-Counter {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Add-Counter.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Adds a counter property' -Tag AddCounter,Add,Counter {
		It "Should number providers" {
			[psobject[]] $providers = Get-PSProvider |Add-Counter.ps1 -PropertyName Position -InitialValue 0 -Force
			foreach($i in 0..($providers.Count -1))
			{
				$providers[$i].Position |Should -Be $i -Because 'Position should be a simple incrementing integer'
			}
		}
		It "Given JSON '<JsonInput>', adding a '<PropertyName>' counter should result in '<JsonOutput>'" -Tag From-One -TestCases @(
			@{ JsonInput = '[{"name": "A"},{"name": "B"},{"name": "C"}]'; PropertyName = 'id'
				JsonOutput = '[{"name":"A","id":1},{"name":"B","id":2},{"name":"C","id":3}]' }
		) {
			Param([string]$JsonInput,[string]$PropertyName,[string]$JsonOutput)
			$JsonInput |
				ConvertFrom-Json |
				Add-Counter.ps1 -PropertyName $PropertyName |
				ConvertTo-Json -Compress |
				Should -BeExactly $JsonOutput -Because 'an incrementing id property should have been added'
		}
	}
}
