<#
.SYNOPSIS
Tests converting an object to an ordered dictionary of properties and values.
#>

Describe 'ConvertTo-OrderedDictionary' -Tag ConvertTo-OrderedDictionary {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir ConvertTo-OrderedDictionary.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Converts an object to an ordered dictionary of properties and values.' `
		-Tag ConvertToOrderedDictionary,Convert,ConvertTo,OrderedDictionary,Dictionary {
		It "Should convert an IO.FileInfo object into a dictionary" {
			$file = Get-Item ConvertTo-OrderedDictionary.ps1 |ConvertTo-OrderedDictionary.ps1
			$file |Should -BeOfType Collections.IDictionary
			$file.Contains('Name') |Should -BeTrue -Because 'the dictionary should include a Name key'
			$file['Name'] |Should -BeOfType string
			$file['Name'] |Should -Be 'ConvertTo-OrderedDictionary.ps1'
			$file.Contains('Length') |Should -BeTrue -Because 'the dictionary should include a Length key'
			$file['Length'] |Should -BeOfType long
			$file.Contains('Mode') |Should -BeTrue -Because 'the dictionary should include a Mode key'
			$file['Mode'] |Should -BeOfType string
			$file.Contains('VersionInfo') |Should -BeTrue -Because 'the dictionary should include a VersionInfo key'
			$file['VersionInfo'] |Should -BeOfType Diagnostics.FileVersionInfo
			$file['VersionInfo'].FileName |Should -BeOfType string
			$file.Contains('CreationTime') |Should -BeTrue -Because 'the dictionary should include a CreationTime key'
			$file['CreationTime'] |Should -BeOfType datetime
		}
	}

}
