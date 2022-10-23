<#
.SYNOPSIS
Tests querying IIS logs.
#>

Describe 'Get-IisLog' -Tag Get-IisLog {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Get-IisLog.ps1" -Severity Warning |
				Should -HaveCount 0 -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Get-IisLog.ps1" -Severity Error |
				Should -HaveCount 0 -Because 'there should be no style errors'
		}
	}
	Context 'Query log directory' -Tag IisLogDirectory {
		It "Query IISW3C logs" -Skip {
			$entry = Get-IisLog.ps1 -LogDirectory "$PSScriptRoot\..\test\data" -After 1996-01-01 -Before 1997-01-01 `
				-UriPathLike '/default.htm' -LogFormat IISW3C
			$entry.Time |Should -Be (Get-Date 1996-01-01T10:48:02Z)
			$entry.Server |Should -Be '192.166.0.24'
			$entry.Line |Should -Be 2
			$entry.IpAddress |Should -Be '195.52.225.44'
			$entry.Username |Should -BeNullOrEmpty
			$entry.UserAgent |Should -Be 'Mozilla/4.0 [en] (WinNT; I)'
			$entry.Method |Should -Be Get
			$entry.UriPath |Should -Be '/default.htm'
			$entry.Query |Should -BeNullOrEmpty
			$entry.Referrer |Should -Be 'http://www.webtrends.com/def_f1.htm'
			$entry.StatusCode |Should -Be 200
			$entry.Status |Should -Be OK
			$entry.SubStatusCode |Should -Be 0
			$entry.SubStatus |Should -BeNullOrEmpty
			$entry.WinStatusCode |Should -Be 0
			$entry.WinStatus |Should -Be ([ComponentModel.Win32Exception]0)
		}
	}
}
