<#
.SYNOPSIS
Tests converting base64-encoded text to bytes or text.
#>

Describe 'ConvertFrom-Base64' -Tag ConvertFrom-Base64 {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertFrom-Base64.ps1
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
	Context 'Converts base64-encoded text to bytes or text' -Tag ConvertFromBase64,Convert,ConvertFrom,Base64 {
		It "Parses a standard base-64 string as parameter" {
			ConvertFrom-Base64.ps1 dXNlcm5hbWU6QmFkUEBzc3dvcmQ= -Encoding utf8 |
				Should -BeExactly 'username:BadP@ssword'
		}
		It "Parses a URI-style base-64 string from pipeline" {
			'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9' |
				ConvertFrom-Base64.ps1 -Encoding ascii -UriStyle |
				Should -BeExactly '{"alg":"HS256","typ":"JWT"}'
		}
		It "Parses a base-64 string from pipeline as a byte array" {
			'77u/dHJ1ZQ0K' |
				ConvertFrom-Base64.ps1 |
				Should -BeExactly ([byte[]]@(0xEF,0xBB,0xBF,0x74,0x72,0x75,0x65,0x0D,0x0A))
		}
	}
}
