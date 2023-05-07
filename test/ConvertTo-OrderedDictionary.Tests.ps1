<#
.SYNOPSIS
Tests converting an object to an ordered dictionary of properties and values.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertTo-OrderedDictionary' -Tag ConvertTo-OrderedDictionary -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
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
