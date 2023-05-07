<#
.SYNOPSIS
Tests producing a basic authentication header string from a credential.
#>

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText','',
Justification='These are tests.')]
$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertTo-BasicAuthentication' -Tag ConvertTo-BasicAuthentication -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
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

