<#
.SYNOPSIS
Tests conversion of a scope level to account for another call stack level.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Add-ScopeLevel' -Tag Add-ScopeLevel -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
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

