<#
.SYNOPSIS
Tests converting a number to a Roman numeral.
#>

Describe 'ConvertTo-RomanNumeral' -Tag ConvertTo-RomanNumeral {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Convert a number to a Roman numeral' -Tag Convert,ConvertTo,ConvertToRomanNumeral,RomanNumeral {
		It "Should convert '<Value>' to '<Result>' (ASCII)" -TestCases @(
			@{ Value = 1; Result = 'I' }
			@{ Value = 2; Result = 'II' }
			@{ Value = 3; Result = 'III' }
			@{ Value = 4; Result = 'IV' }
			@{ Value = 5; Result = 'V' }
			@{ Value = 6; Result = 'VI' }
			@{ Value = 7; Result = 'VII' }
			@{ Value = 8; Result = 'VIII' }
			@{ Value = 9; Result = 'IX' }
			@{ Value = 10; Result = 'X' }
			@{ Value = 11; Result = 'XI' }
			@{ Value = 12; Result = 'XII' }
			@{ Value = 13; Result = 'XIII' }
			@{ Value = 14; Result = 'XIV' }
			@{ Value = 15; Result = 'XV' }
			@{ Value = 16; Result = 'XVI' }
			@{ Value = 17; Result = 'XVII' }
			@{ Value = 18; Result = 'XVIII' }
			@{ Value = 19; Result = 'XIX' }
			@{ Value = 20; Result = 'XX' }
			@{ Value = 21; Result = 'XXI' }
			@{ Value = 22; Result = 'XXII' }
			@{ Value = 23; Result = 'XXIII' }
			@{ Value = 24; Result = 'XXIV' }
			@{ Value = 25; Result = 'XXV' }
			@{ Value = 35; Result = 'XXXV' }
			@{ Value = 45; Result = 'XLV' }
			@{ Value = 46; Result = 'XLVI' }
			@{ Value = 47; Result = 'XLVII' }
			@{ Value = 48; Result = 'XLVIII' }
			@{ Value = 49; Result = 'XLIX' }
			@{ Value = 50; Result = 'L' }
			@{ Value = 51; Result = 'LI' }
			@{ Value = 52; Result = 'LII' }
			@{ Value = 99; Result = 'XCIX' }
			@{ Value = 100; Result = 'C' }
			@{ Value = 999; Result = 'CMXCIX' }
			@{ Value = 1000; Result = 'M' }
			@{ Value = 1111; Result = 'MCXI' }
			@{ Value = 2020; Result = 'MMXX' }
			@{ Value = 2022; Result = 'MMXXII' }
		) {
			Param([int] $Value, [string] $Result)
			ConvertTo-RomanNumeral.ps1 $Value |Should -BeExactly $Result
		}
		It "Should convert '<Value>' to '<Result>' (Unicode)" -TestCases @(
			@{ Value = 1; Result = 'Ⅰ' }
			@{ Value = 2; Result = 'Ⅱ' }
			@{ Value = 3; Result = 'Ⅲ' }
			@{ Value = 4; Result = 'Ⅳ' }
			@{ Value = 5; Result = 'Ⅴ' }
			@{ Value = 6; Result = 'Ⅵ' }
			@{ Value = 7; Result = 'Ⅶ' }
			@{ Value = 8; Result = 'Ⅷ' }
			@{ Value = 9; Result = 'Ⅸ' }
			@{ Value = 10; Result = 'Ⅹ' }
			@{ Value = 11; Result = 'ⅩⅠ' }
			@{ Value = 12; Result = 'ⅩⅡ' }
			@{ Value = 13; Result = 'ⅩⅢ' }
			@{ Value = 14; Result = 'ⅩⅣ' }
			@{ Value = 15; Result = 'ⅩⅤ' }
			@{ Value = 16; Result = 'ⅩⅥ' }
			@{ Value = 17; Result = 'ⅩⅦ' }
			@{ Value = 18; Result = 'ⅩⅧ' }
			@{ Value = 19; Result = 'ⅩⅨ' }
			@{ Value = 20; Result = 'ⅩⅩ' }
			@{ Value = 21; Result = 'ⅩⅩⅠ' }
			@{ Value = 22; Result = 'ⅩⅩⅡ' }
			@{ Value = 23; Result = 'ⅩⅩⅢ' }
			@{ Value = 24; Result = 'ⅩⅩⅣ' }
			@{ Value = 25; Result = 'ⅩⅩⅤ' }
			@{ Value = 35; Result = 'ⅩⅩⅩⅤ' }
			@{ Value = 45; Result = 'ⅩⅬⅤ' }
			@{ Value = 46; Result = 'ⅩⅬⅥ' }
			@{ Value = 47; Result = 'ⅩⅬⅦ' }
			@{ Value = 48; Result = 'ⅩⅬⅧ' }
			@{ Value = 49; Result = 'ⅩⅬⅨ' }
			@{ Value = 50; Result = 'Ⅼ' }
			@{ Value = 51; Result = 'ⅬⅠ' }
			@{ Value = 52; Result = 'ⅬⅡ' }
			@{ Value = 99; Result = 'ⅩⅭⅨ' }
			@{ Value = 100; Result = 'Ⅽ' }
			@{ Value = 999; Result = 'ⅭⅯⅩⅭⅠⅩ' }
			@{ Value = 1000; Result = 'Ⅿ' }
			@{ Value = 1111; Result = 'ⅯⅭⅩⅠ' }
			@{ Value = 2020; Result = 'ⅯⅯⅩⅩ' }
			@{ Value = 2022; Result = 'ⅯⅯⅩⅩⅡ' }
		) {
			Param([int] $Value, [string] $Result)
			ConvertTo-RomanNumeral.ps1 $Value -Unicode |Should -BeExactly $Result
		}
	}
}
