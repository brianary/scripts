<#
.SYNOPSIS
Tests converting a string of hexadecimal digits into a byte array.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertFrom-Hex' -Tag ConvertFrom-Hex -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
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
