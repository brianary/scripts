<#
.SYNOPSIS
Tests converting an integer Unix (POSIX) time (seconds since Jan 1, 1970) into a DateTime value.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertFrom-EpochTime' -Tag ConvertFrom-EpochTime -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Converts an integer Unix (POSIX) time (seconds since Jan 1, 1970) into a DateTime value' `
		-Tag ConvertFromEpochTime,ConvertFrom,Convert,EpochTime {
		It "Epoch time '<EpochTime>' is converted to '<Result>'" -TestCases @(
			@{ EpochTime = 946684800; Result = '2000-01-01' }
			@{ EpochTime = 1012615322; Result = '2002-02-02T02:02:02' }
			@{ EpochTime = 1645568542; Result = '2022-02-22T22:22:22' }
			@{ EpochTime = 0; Result = '1970-01-01' }
			@{ EpochTime = 663486600; Result = '1991-01-10T05:50' }
		) {
			Param([int] $EpochTime, [datetime] $Result)
			$EpochTime |ConvertFrom-EpochTime.ps1 |Should -BeExactly $Result
		}
	}

}
