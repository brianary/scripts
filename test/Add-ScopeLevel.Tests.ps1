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
	Context 'Convert a scope level to account for another call stack level.' -Tag AddScopeLevel,Add,ScopeLevel {
		It 'Should calculate local scope' {
			Add-ScopeLevel.ps1 Local |Should -BeExactly '1' -Because 'local is zero scope'
		}
		It 'Should calculate a numeric scope' {
			1..8 |ForEach-Object {Add-ScopeLevel.ps1 $_ |Should -BeExactly "$($_+1)"}
		}
		It 'Should calulate global scope' {
			Add-ScopeLevel.ps1 Global |Should -BeExactly Global -Because 'global is the top scope'
		}
	}
}
