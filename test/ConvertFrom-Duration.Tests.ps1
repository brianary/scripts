<#
.SYNOPSIS
Tests parsing a Timespan from a ISO8601 duration string.
#>

Describe 'ConvertFrom-Duration' -Tag ConvertFrom-Duration {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertFrom-Duration.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Warning |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path $ScriptName -Severity Error |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style errors'
		}
	}
	Context 'Parses a Timespan from a ISO8601 duration string' `
		-Tag ConvertFromDuration,Convert,ConvertFrom,Duration,TimeSpan {
		BeforeAll {Mock Write-Warning {Write-Information $Message}}
		It "Should parse '<Duration>' as '<TimeSpan>'" -TestCases @(
			@{ Duration = 'PT1S'; TimeSpan = '0:00:01' }
			@{ Duration = 'PT1M'; TimeSpan = '0:01:00' }
			@{ Duration = 'PT1H'; TimeSpan = '1:00:00' }
			@{ Duration = 'P1D'; TimeSpan = '1.0:00:00' }
			@{ Duration = 'P1W'; TimeSpan = '7.0:00:00' }
			@{ Duration = 'P1M'; TimeSpan = '30.0:00:00'; Warnings = 'Adding month(s) as a mean number of days (30.436875).' }
			@{ Duration = 'P1Y'; TimeSpan = '365.0:00:00'; Warnings = 'Adding year(s) as a mean number of days (365.2425).' }
			@{ Duration = 'PT72H10M'; TimeSpan = '3.00:10:00' }
			@{ Duration = 'P90DT8H'; TimeSpan = '90.08:00:00' }
			@{ Duration = 'P3DT48H90M300S'; TimeSpan = '5.01:35:00' }
			@{ Duration = 'P1Y3M2DT8H20M15S'; TimeSpan = '458.08:20:15'
				Warnings = 'Adding year(s) as a mean number of days (365.2425).',
					'Adding month(s) as a mean number of days (30.436875).' }
			@{ Duration = 'P3Y6M4DT12H30M5S'; TimeSpan = '1283.12:30:05'
				Warnings = 'Adding year(s) as a mean number of days (365.2425).',
					'Adding month(s) as a mean number of days (30.436875).' }
		) {
			Param([string]$Duration,[timespan]$TimeSpan,[string[]]$Warnings = @())
			ConvertFrom-Duration.ps1 $Duration |Should -BeExactly $TimeSpan
			if($Warnings)
			{
				Assert-MockCalled -CommandName Write-Warning -Times ($Warnings.Count) -ParameterFilter {$Message -in $Warnings}
			}
		}
	}
}
