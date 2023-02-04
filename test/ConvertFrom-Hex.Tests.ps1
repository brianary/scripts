<#
.SYNOPSIS
Tests converting a string of hexadecimal digits into a byte array.
#>

Describe 'ConvertFrom-Hex' -Tag ConvertFrom-Hex {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertFrom-Hex.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Convert a string of hexadecimal digits into a byte array' -Tag ConvertFromHex,Convert,ConvertFrom,Hex {
		It "The value '<Value>' should return '<Result>'" -TestCases @(
			@{ Value = 'EF BB BF'; Result = 0xEF,0xBB,0xBF }
			@{ Value = 'c0ffee'; Result = 0xC0,0xFF,0xEE }
			@{ Value = '0x25504446'; Result = 0x25,0x50,0x44,0x46 }
		) {
			Param([string]$Value,[byte[]]$Result)
			ConvertFrom-Hex.ps1 $Value |Should -BeExactly $Result -Because 'the parameter should work'
			$Value |ConvertFrom-Hex.ps1 |Should -BeExactly $Result -Because 'pipeline input should work'
		}
	}
}
