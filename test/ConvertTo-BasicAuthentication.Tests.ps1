<#
.SYNOPSIS
Tests producing a basic authentication header string from a credential.
#>

Describe 'ConvertTo-BasicAuthentication' -Tag ConvertTo-BasicAuthentication {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertTo-BasicAuthentication.ps1
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
	Context 'Produces a basic authentication header string from a credential' `
		-Tag ConvertToBasicAuthentication,Convert,ConvertTo,BasicAuthentication,Authentication,Credential {
		It "Credential '<UserName>' with password '<SingleFactor>' should return '<Result>'" -TestCases @(
			@{ UserName = 'eroot'; SingleFactor = 'w@terHous3'; Result = 'Basic ZXJvb3Q6d0B0ZXJIb3VzMw==' }
			@{ UserName = 'hcase'; SingleFactor = '//mrrrChds1'; Result = 'Basic aGNhc2U6Ly9tcnJyQ2hkczE=' }
			@{ UserName = 'hprot'; SingleFactor = 'pr1mpCtrl!'; Result = 'Basic aHByb3Q6cHIxbXBDdHJsIQ==' }
		) {
			Param([string]$UserName,[string]$SingleFactor,[string]$Result)
			$credential = New-Object pscredential $UserName,(ConvertTo-SecureString $SingleFactor -AsPlainText -Force)
			ConvertTo-BasicAuthentication.ps1 $credential |Should -BeExactly $Result -Because 'parameter should work'
			$credential |ConvertTo-BasicAuthentication.ps1 |Should -BeExactly $Result -Because 'pipeline should work'
		}
	}
}
