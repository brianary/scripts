<#
.SYNOPSIS
Tests formattting a datetime as a LogParser literal.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertTo-LogParserTimestamp' -Tag ConvertTo-LogParserTimestamp -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Formats a datetime as a LogParser literal' `
		-Tag ConvertToLogParserTimestamp,Convert,ConvertTo,LogParserTimestamp,LogParser {
		It "Converts '<DateTime>' into a LogParser timestamp expression" -TestCases @(
			@{ DateTime = (Get-Date) }
			@{ DateTime = '2000-01-01' }
			@{ DateTime = '2002-02-20 02:20:02' }
			@{ DateTime = '2022-02-22 22:20:20' }
			@{ DateTime =  (Get-Date '1970-01-01Z').AddSeconds((Get-Random)) }
			@{ DateTime =  (Get-Date '1970-01-01Z').AddSeconds((Get-Random)) }
			@{ DateTime =  (Get-Date '1970-01-01Z').AddSeconds((Get-Random)) }
			@{ DateTime =  (Get-Date '1970-01-01Z').AddSeconds((Get-Random)) }
			@{ DateTime =  (Get-Date '1970-01-01Z').AddSeconds((Get-Random)) }
		) {
			Param([datetime] $DateTime)
			$DateTime |
				ConvertTo-LogParserTimestamp.ps1 |
				Should -BeExactly "timestamp('$(Get-Date $DateTime -f 'yyyy-MM-dd HH:mm:ss')','yyyy-MM-dd HH:mm:ss')" `
				-Because 'pipeline should work'
			ConvertTo-LogParserTimestamp.ps1 $DateTime |
				Should -BeExactly "timestamp('$(Get-Date $DateTime -f 'yyyy-MM-dd HH:mm:ss')','yyyy-MM-dd HH:mm:ss')" `
				-Because 'parameter should work'
		}
	}
}

