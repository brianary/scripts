<#
.SYNOPSIS
Tests adding an incrementing integer property to each pipeline object.
#>

Describe 'Add-Counter' -Tag Add-Counter {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
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
