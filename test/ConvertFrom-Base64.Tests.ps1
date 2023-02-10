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
	Context 'Converts base64-encoded text to bytes or text' -Tag ConvertFromBase64,Convert,ConvertFrom,Base64 {
		It "Should parse a standard base-64 string as parameter" {
			ConvertFrom-Base64.ps1 dXNlcm5hbWU6QmFkUEBzc3dvcmQ= -Encoding utf8 |
				Should -BeExactly 'username:BadP@ssword'
		}
		It "Should parse a URI-style base-64 string from pipeline" {
			'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9' |
				ConvertFrom-Base64.ps1 -Encoding ascii -UriStyle |
				Should -BeExactly '{"alg":"HS256","typ":"JWT"}'
		}
		It "Should parse a base-64 string from pipeline as a byte array" {
			'77u/dHJ1ZQ0K' |
				ConvertFrom-Base64.ps1 |
				Should -BeExactly ([byte[]]@(0xEF,0xBB,0xBF,0x74,0x72,0x75,0x65,0x0D,0x0A))
		}
	}
}
