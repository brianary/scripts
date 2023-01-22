<#
.SYNOPSIS
Tests converting bytes or text to base64-encoded text.
#>

Describe 'ConvertTo-Base64' -Tag ConvertTo-Base64 {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertTo-Base64.ps1
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
	Context 'Converts bytes or text to base64-encoded text.' -Tag ConvertToBase64,Convert,ConvertTo,Base64 {
		It "Should encode a string parameter as a standard base-64 string" {
			ConvertTo-Base64.ps1 'username:BadP@ssword' -Encoding utf8 |
				Should -BeExactly 'dXNlcm5hbWU6QmFkUEBzc3dvcmQ='
		}
		It "Should encode a string from pipeline to a URI-style base-64 string" {
			'{"alg":"HS256","typ":"JWT"}' |
				ConvertTo-Base64.ps1 -UriStyle |
				Should -BeExactly 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
		}
		It "Should encode a byte array from pipeline to a base-64 string from pipeline" {
			,([byte[]]@(0xEF,0xBB,0xBF,0x74,0x72,0x75,0x65,0x0D,0x0A)) |
				ConvertTo-Base64.ps1 |
				Should -BeExactly '77u/dHJ1ZQ0K'
		}
	}
}
