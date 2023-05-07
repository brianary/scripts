<#
.SYNOPSIS
Tests converting bytes or text to base64-encoded text.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertTo-Base64' -Tag ConvertTo-Base64 -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
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

