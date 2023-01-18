<#
.SYNOPSIS
Tests conversion of a scope level to account for another call stack level.
#>

Describe 'Add-ScopeLevel' -Tag Add-ScopeLevel {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Add-ScopeLevel.ps1
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
				ForEach-Object {"$($_.Severity): $($_.ScriptName):$($_.Line):$($_.Column): $($_.RuleName): $($_.Message)"} |
				Should -BeExactly $null -Because 'there should be no style errors'
		}
	}
	Context 'Convert a scope level to account for another call stack level.' -Tag AddScopeLevel,Add,ScopeLevel {
		It 'Calculates local scope' {
			Add-ScopeLevel.ps1 Local |Should -BeExactly '1' -Because 'local is zero scope'
		}
		It 'Calculates a numeric scope' {
			1..8 |ForEach-Object {Add-ScopeLevel.ps1 $_ |Should -BeExactly "$($_+1)"}
		}
		It 'Calulates global scope' {
			Add-ScopeLevel.ps1 Global |Should -BeExactly Global -Because 'global is the top scope'
		}
	}
}
