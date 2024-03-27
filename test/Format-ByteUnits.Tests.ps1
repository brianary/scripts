<#
.SYNOPSIS
Tests converting bytes to largest possible units, to improve readability.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Format-ByteUnits' -Tag Format-ByteUnits -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Converts bytes to largest possible units, to improve readability' -Tag FormatByteUnits,Format,ByteUnits {
		It "Formatting '<Bytes>', up to '<Precision>' digits after the decimal returns '<Result>', or '<SIResult> for SI'" -TestCases @(
			@{ Bytes = 0; Precision = 16; Result = '0'; SIResult = '0' }
			@{ Bytes = 1; Precision = 16; Result = '1'; SIResult = '1 B' }
			@{ Bytes = 999; Precision = 16; Result = '999'; SIResult = '999 B' }
			@{ Bytes = 0KB; Precision = 16; Result = '0'; SIResult = '0' }
			@{ Bytes = 1KB; Precision = 16; Result = '1KB'; SIResult = '1 KiB' }
			@{ Bytes = 999KB; Precision = 16; Result = '999KB'; SIResult = '999 KiB' }
			@{ Bytes = 1MB; Precision = 16; Result = '1MB'; SIResult = '1 MiB' }
			@{ Bytes = 999MB; Precision = 16; Result = '999MB'; SIResult = '999 MiB' }
			@{ Bytes = 1GB; Precision = 16; Result = '1GB'; SIResult = '1 GiB' }
			@{ Bytes = 999GB; Precision = 16; Result = '999GB'; SIResult = '999 GiB' }
			@{ Bytes = 1TB; Precision = 16; Result = '1TB'; SIResult = '1 TiB' }
			@{ Bytes = 999TB; Precision = 16; Result = '999TB'; SIResult = '999 TiB' }
			@{ Bytes = 1PB; Precision = 16; Result = '1PB'; SIResult = '1 PiB' }
			@{ Bytes = 999PB; Precision = 16; Result = '999PB'; SIResult = '999 PiB' }
			@{ Bytes = 999999999999999999N; Precision = 2; Result = '888.18PB'; SIResult = '888.18 PiB' }
			@{ Bytes = 1234567890L; Precision = 2; Result = '1.15GB'; SIResult = '1.15 GiB' }
			@{ Bytes = 1234567890L; Precision = 1; Result = '1.1GB'; SIResult = '1.1 GiB' }
			@{ Bytes = 1234567890L; Precision = 0; Result = '1GB'; SIResult = '1 GiB' }
			@{ Bytes = 987654321000; Precision = 16; Result = '919.824765063822GB'; SIResult = '919.824765063822 GiB' }
			@{ Bytes = 987654321000; Precision = 12; Result = '919.824765063822GB'; SIResult = '919.824765063822 GiB' }
			@{ Bytes = 987654321000; Precision = 11; Result = '919.82476506382GB'; SIResult = '919.82476506382 GiB' }
			@{ Bytes = 987654321000; Precision = 10; Result = '919.8247650638GB'; SIResult = '919.8247650638 GiB' }
			@{ Bytes = 987654321000; Precision = 9; Result = '919.824765064GB'; SIResult = '919.824765064 GiB' }
			@{ Bytes = 987654321000; Precision = 8; Result = '919.82476506GB'; SIResult = '919.82476506 GiB' }
			@{ Bytes = 987654321000; Precision = 7; Result = '919.8247651GB'; SIResult = '919.8247651 GiB' }
			@{ Bytes = 987654321000; Precision = 6; Result = '919.824765GB'; SIResult = '919.824765 GiB' }
			@{ Bytes = 987654321000; Precision = 5; Result = '919.82477GB'; SIResult = '919.82477 GiB' }
			@{ Bytes = 987654321000; Precision = 4; Result = '919.8248GB'; SIResult = '919.8248 GiB' }
			@{ Bytes = 987654321000; Precision = 3; Result = '919.825GB'; SIResult = '919.825 GiB' }
			@{ Bytes = 987654321000; Precision = 2; Result = '919.82GB'; SIResult = '919.82 GiB' }
			@{ Bytes = 987654321000; Precision = 1; Result = '919.8GB'; SIResult = '919.8 GiB' }
			@{ Bytes = 987654321000; Precision = 0; Result = '920GB'; SIResult = '920 GiB' }
			@{ Bytes = 9685059; Precision = 1; Result = '9.2MB'; SIResult = '9.2 MiB' }
		) {
			Param([bigint] $Bytes, [byte] $Precision, [string] $Result, [string] $SIResult)
			Format-ByteUnits.ps1 -Bytes $Bytes -Precision $Precision |
				Should -BeExactly $Result -Because 'parameter should work'
			$Bytes |Format-ByteUnits.ps1 -Precision $Precision |
				Should -BeExactly $Result -Because 'pipeline should work'
			Format-ByteUnits.ps1 -Bytes $Bytes -Precision $Precision -UseSI |
				Should -BeExactly $SIResult -Because 'SI parameter should work'
			$Bytes |Format-ByteUnits.ps1 -Precision $Precision -UseSI |
				Should -BeExactly $SIResult -Because 'SI pipeline should work'
		}
	}

}
