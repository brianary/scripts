<#
.SYNOPSIS
Tests adding a timespan to DateTime values.
#>

Describe 'Add-TimeSpan' -Tag Add-TimeSpan {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Add-TimeSpan.ps1
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
	Context 'Adds a timespan to DateTime values.' -Tag AddTimeSpan,Add,TimeSpan {
		It "Should add '<TimeSpan>' to a '<DateTime>' pipeline value and return '<Result>'" -TestCases @(
			@{ TimeSpan = '00:00:30'; DateTime = '2000-01-01'; Result = '2000-01-01T00:00:30' }
			@{ TimeSpan = '00:00:59'; DateTime = '2020-12-31T23:59:00'; Result = '2020-12-31T23:59:59' }
			@{ TimeSpan = '00:00:30'; DateTime = '2010-07-01T00:00:00'; Result = '2010-07-01T00:00:30' }
			@{ TimeSpan = '7'; DateTime = '2000-01-01T00:00:00'; Result = '2000-01-08T00:00:00' }
			@{ TimeSpan = '100'; DateTime = '2020-12-31T23:59:00'; Result = '2021-04-10T23:59:00' }
			@{ TimeSpan = '60'; DateTime = '2010-07-01T00:00:00'; Result = '2010-08-30T00:00:00' }
			@{ TimeSpan = 7; DateTime = '2000-01-01T00:00:00'; Result = '2000-01-01T00:00:00.0000007' }
			@{ TimeSpan = 100; DateTime = '2020-12-31T23:59:00'; Result = '2020-12-31T23:59:00.00001' }
			@{ TimeSpan = 60; DateTime = '2010-07-01T00:00:00'; Result = '2010-07-01T00:00:00.000006' }
		) {
			Param($TimeSpan,[datetime]$DateTime,[datetime]$Result)
			$DateTime |Add-TimeSpan.ps1 $TimeSpan |Should -Be $Result
		}
	}
}
