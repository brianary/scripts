<#
.SYNOPSIS
Tests converting a DateTime value into an integer Unix (POSIX) time, seconds since Jan 1, 1970.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertTo-EpochTime' -Tag ConvertTo-EpochTime -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Converts a DateTime value into an integer Unix (POSIX) time, seconds since Jan 1, 1970' `
		-Tag ConvertToEpochTime,Convert,ConvertTo,EpochTime {
		It "DateTime value '<DateTime>' should return '<Result>'" `
			-Tag ConvertToEpochTime,Convert,ConvertTo,EpochTime,Epoch -TestCases @(
			@{ DateTime = '2000-01-01Z'; Result = 946684800 }
			@{ DateTime = '2002-02-02T02:02:02Z'; Result = 1012615322 }
			@{ DateTime = '2022-02-22T22:22:22Z'; Result = 1645568542 }
			@{ DateTime = '1970-01-01Z'; Result = 0 }
			@{ DateTime = '1991-01-10T05:50Z'; Result = 663486600 }
		) {
			Param([datetime]$DateTime,[int]$Result)
			ConvertTo-EpochTime.ps1 $DateTime |Should -BeExactly $Result -Because 'parameter should work'
			$DateTime |ConvertTo-EpochTime.ps1 |Should -BeExactly $Result -Because 'pipeline should work'
		}
	}
}
