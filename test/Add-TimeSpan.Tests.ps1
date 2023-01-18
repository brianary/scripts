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
		It 'Add seconds' {
			Get-Date 2000-01-01T00:00:00 |Add-TimeSpan.ps1 00:00:30 |Should -Be (Get-Date 2000-01-01T00:00:30)
			Get-Date 2020-12-31T23:59:00 |Add-TimeSpan.ps1 00:00:59 |Should -Be (Get-Date 2020-12-31T23:59:59)
			Get-Date 2010-07-01T00:00:00 |Add-TimeSpan.ps1 00:00:30 |Should -Be (Get-Date 2010-07-01T00:00:30)
		}
		It 'Add days' {
			Get-Date 2000-01-01T00:00:00 |Add-TimeSpan.ps1 '7' |Should -Be (Get-Date 2000-01-08T00:00:00)
			Get-Date 2020-12-31T23:59:00 |Add-TimeSpan.ps1 '100' |Should -Be (Get-Date 2021-04-10T23:59:00)
			Get-Date 2010-07-01T00:00:00 |Add-TimeSpan.ps1 '60' |Should -Be (Get-Date 2010-08-30T00:00:00)
		}
		It 'Add milliseconds' {
			Get-Date 2000-01-01T00:00:00 |Add-TimeSpan.ps1 7 |Should -Be (Get-Date 2000-01-01T00:00:00.0000007)
			Get-Date 2020-12-31T23:59:00 |Add-TimeSpan.ps1 100 |Should -Be (Get-Date 2020-12-31T23:59:00.00001)
			Get-Date 2010-07-01T00:00:00 |Add-TimeSpan.ps1 60 |Should -Be (Get-Date 2010-07-01T00:00:00.000006)
		}
	}
}
