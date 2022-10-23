<#
.SYNOPSIS
Tests querying IIS logs.
#>

Describe 'Get-IisLog' -Tag Get-IisLog {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		try
		{
			Use-Command.ps1 logparser "${env:ProgramFiles(x86)}\Log Parser 2.2\LogParser.exe" -EA Stop `
				-msi http://download.microsoft.com/download/f/f/1/ff1819f9-f702-48a5-bbc7-c9656bc74de8/LogParser.msi
			$Global:noLogParser = !(Get-Command logparser -EA 0)
		}
		catch {Write-Warning 'Could not install LogParser'; $Global:noLogParser = $true}
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
		It "Query very old IISW3C logs" -Skip:$Global:noLogParser {
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
			$entry.WinStatus.NativeErrorCode |Should -Be 0
			$entry.WinStatus.Message |Should -Be 'The operation completed successfully.'
		}
		It "Query old IISW3C logs from IIS 7.0" -Skip:$Global:noLogParser {
			$entry = Get-IisLog.ps1 -LogDirectory "$PSScriptRoot\..\test\data" -After 2010-08-15 -Before 2010-08-16 `
				-UriPathLike /robots.txt -LogFormat IISW3C |
				Where-Object UserAgent -like '*Firefox*'
			$entry.Time |Should -Be (Get-Date 2010-08-15T21:28:09Z)
			$entry.Server |Should -Be '67.222.136.138:80'
			$entry.Line |Should -Be 49
			$entry.IpAddress |Should -Be '64.246.165.160'
			$entry.Username |Should -BeNullOrEmpty
			$entry.UserAgent |Should -Be ('Mozilla/5.0 (Windows; U; Windows NT 5.1; en; rv:1.9.0.13) Gecko/2009073022 ' +
				'Firefox/3.5.2 (.NET CLR 3.5.30729) SurveyBot/2.3 (DomainTools)')
			$entry.Method |Should -Be Get
			$entry.UriPath |Should -Be '/robots.txt'
			$entry.Query |Should -BeNullOrEmpty
			$entry.Referrer |Should -BeNullOrEmpty
			$entry.StatusCode |Should -Be 404
			$entry.Status |Should -Be NotFound
			$entry.SubStatusCode |Should -Be 2
			$entry.SubStatus |Should -Be 'ISAPI or CGI restriction.'
			$entry.WinStatusCode |Should -Be 0
			$entry.WinStatus.NativeErrorCode |Should -Be 0
			$entry.WinStatus.Message |Should -Be 'The operation completed successfully.'
		}
		It "Query old IISW3C logs from IIS 8.5" -Skip:$Global:noLogParser {
			$entry = Get-IisLog.ps1 -LogDirectory test\data -After 2016-01-10 -Before 2016-01-11 `
				-UriPathLike '/images/logo.png' -LogFormat IISW3C
			$entry.Time |Should -Be (Get-Date 2016-01-10T15:48:55Z)
			$entry.Server |Should -Be '172.31.22.76:80'
			$entry.Line |Should -Be 90
			$entry.IpAddress |Should -Be '200.41.111.69'
			$entry.Username |Should -BeNullOrEmpty
			$entry.UserAgent |Should -Be 'Mozilla/4.0 (compatible;)'
			$entry.Method |Should -Be Get
			$entry.UriPath |Should -Be '/images/logo.png'
			$entry.Query |Should -BeNullOrEmpty
			$entry.Referrer |Should -BeNullOrEmpty
			$entry.StatusCode |Should -Be 304
			$entry.Status |Should -Be NotModified
			$entry.SubStatusCode |Should -Be 0
			$entry.SubStatus |Should -BeNullOrEmpty
			$entry.WinStatusCode |Should -Be 0
			$entry.WinStatus.NativeErrorCode |Should -Be 0
			$entry.WinStatus.Message |Should -Be 'The operation completed successfully.'
		}
	}
}
