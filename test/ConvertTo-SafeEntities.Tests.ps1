<#
.SYNOPSIS
Tests encoding text as XML/HTML, escaping all characters outside 7-bit ASCII.
#>

#Requires -Version 7
Describe 'ConvertTo-SafeEntities' -Tag ConvertTo-SafeEntities {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Encode text as XML/HTML, escaping all characters outside 7-bit ASCII' `
		-Tag Convert,ConvertTo,ConvertToSafeEntities,SafeEntities,Entities,HTML,XML {
		It "Should convert '<Value>' to '<Result>'" -TestCases @(
			@{ Value = "$([Text.Rune]0x1F4A1) File $([char]0x2192) Save"; Result = '&#x1F4A1; File &#x2192; Save' }
			@{ Value = "$([char]0xD83D)$([char]0xDCA1) File $([char]0x2192) Save"; Result = '&#x1F4A1; File &#x2192; Save' }
			@{ Value = "ETA: $([char]0xBD) hour"; Result = 'ETA: &#xBD; hour' }
			@{ Value = "$([Text.Rune]0x1F41B) fix bug"; Result = '&#x1F41B; fix bug' }
			@{ Value = "$([char]0xD83D)$([char]0xDC1B) fix bug"; Result = '&#x1F41B; fix bug' }
			@{ Value = "$([Text.Rune]0x1F9EA) new test"; Result = '&#x1F9EA; new test' }
			@{ Value = "$([char]0xD83E)$([char]0xDDEA) new test"; Result = '&#x1F9EA; new test' }
		) {
			Param([string] $Value, [string] $Result)
			$Value |ConvertTo-SafeEntities.ps1 |Should -BeExactly $Result -Because 'pipeline should work'
			ConvertTo-SafeEntities.ps1 $Value |Should -BeExactly $Result -Because 'parameter should work'
		}
	}
}
