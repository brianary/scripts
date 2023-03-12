<#
.SYNOPSIS
Tests replacing the name of each environment variable embedded in the specified string with the string equivalent of the value of the variable, then returns the resulting string.
#>

Describe 'Expand-EnvironmentVariables' -Tag Expand-EnvironmentVariables {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Replaces the name of each environment variable embedded in the specified string with the string equivalent of the value of the variable, then returns the resulting string' `
		-Tag ExpandEnvironmentVariables,Expand,EnvironmentVariables,EnvVar {
		It "Expands '<String>' to '<Result>'" -TestCases @(
			@{ String = '%SystemRoot%\System32\cmd.exe'; Result = 'C:\WINDOWS\System32\cmd.exe' }
			@{ String = '%CommonProgramFiles%\System\ado'; Result = 'C:\Program Files\Common Files\System\ado' }
		) {
			Param([string] $String, [string] $Result)
			Expand-EnvironmentVariables.ps1 $String |Should -Be $Result -Because 'parameter should work'
			$String |Expand-EnvironmentVariables.ps1 |Should -Be $Result -Because 'pipeline should work'
		}
	}
}
