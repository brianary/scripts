<#
.SYNOPSIS
Tests creating multipart/form-data to send as a request body.
#>

$datadir = Join-Path $PSScriptRoot .. 'test','data'
Describe 'ConvertTo-MultipartFormData' -Tag ConvertTo-MultipartFormData {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertTo-MultipartFormData.ps1
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
	Context 'Creates multipart/form-data to send as a request body' `
		-Tag ConvertToMultipartFormData,Convert,ConvertTo,MultipartFormData,WebRequest {
		Mock New-Guid {return [guid]'d9b96b2b-e95d-4051-86fa-81a4b98a6dda'}
		It "Sets header values for content type" {
			'Invoke-WebRequest:ContentType','Invoke-RestMethod:ContentType' |
				Should -Not -BeIn $PSDefaultParameterValues.Keys -Because 'content type header should not exist'
			ConvertTo-MultipartFormData.ps1 @{ A = 1 } |
				ForEach-Object {
					'Invoke-WebRequest:ContentType','Invoke-RestMethod:ContentType' |
						Should -BeIn $PSDefaultParameterValues.Keys -Because 'content type header should exist'
					$PSDefaultParameterValues['Invoke-WebRequest:ContentType'] |
						Should -BeLikeExactly 'multipart/form-data; boundary=*'
					$PSDefaultParameterValues['Invoke-RestMethod:ContentType'] |
						Should -BeLikeExactly 'multipart/form-data; boundary=*'
				}
		}
		It "Converts a dictionary of form values to a UTF-8 byte array body" -TestCases @(
			@{ FormValues = [ordered]@{ A = 1 } }
			@{ FormValues = [ordered]@{ Name = 'Sheldon Powers'; Agree = 'on' } }
		) {
			Param([Collections.IDictionary] $FormValues, [byte[]] $Result)
			$textresult = [text.encoding]::UTF8.GetString((ConvertTo-MultipartFormData.ps1 $FormValues))
			$FormValues.Keys |ForEach-Object {$textresult |Should -BeLikeExactly "*Content-Disposition: form-data; name=$_*"}
		}
	}
}
