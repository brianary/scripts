<#
.SYNOPSIS
Tests conversion of a scope level to account for another call stack level.
#>

Describe 'Add-ScopeLevel' -Tag Add-ScopeLevel {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-ScopeLevel.ps1" -Severity Warning |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-ScopeLevel.ps1" -Severity Error |
				ForEach-Object {"$($_.Severity): $($_.ScriptName):$($_.Line):$($_.Column): $($_.RuleName): $($_.Message)"} |
				Should -BeExactly $null -Because 'there should be no style errors'
		}
	}
	Context 'Convert a scope level to account for another call stack level.' -Tag ScopeLevel {
		It 'Calculates local scope' {
			Add-ScopeLevel.ps1 Local |Should -BeExactly '1'
		}
		It 'Calculates a numeric scope' {
			1..8 |ForEach-Object {Add-ScopeLevel.ps1 $_ |Should -BeExactly "$($_+1)"}
		}
		It 'Calulates global scope' {
			Add-ScopeLevel.ps1 Global |Should -BeExactly 'Global'
		}
	}
}
