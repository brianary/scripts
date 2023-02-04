<#
.SYNOPSIS
Tests formattting a datetime as a LogParser literal.
#>

Describe 'ConvertTo-LogParserTimestamp' -Tag ConvertTo-LogParserTimestamp {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertTo-LogParserTimestamp.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
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
