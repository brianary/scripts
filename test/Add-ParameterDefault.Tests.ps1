<#
.SYNOPSIS
Tests appending or creating a value to use for the specified cmdlet parameter to use when one is not specified.
#>

Describe 'Add-ParameterDefault' -Tag Add-ParameterDefault {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Appends or creates a value to use for the specified cmdlet parameter to use when one is not specified.' -Tag Example {
		It "Setting a simple default" {
			Add-ParameterDefault.ps1 epcsv nti $true -Scope Global
			$PSDefaultParameterValues.ContainsKey('Export-Csv:NoTypeInformation') |Should -BeTrue
			$PSDefaultParameterValues['Export-Csv:NoTypeInformation'] |Should -BeTrue
		}
		It "Setting a hashtable default" {
			Add-ParameterDefault.ps1 Select-Xml Namespace @{svg = 'http://www.w3.org/2000/svg'}
			$PSDefaultParameterValues.ContainsKey('Select-Xml:Namespace') |Should -BeTrue
			$PSDefaultParameterValues['Select-Xml:Namespace'].ContainsKey('svg') |Should -BeTrue
			$PSDefaultParameterValues['Select-Xml:Namespace']['svg'] |Should -BeExactly 'http://www.w3.org/2000/svg'
		}
	}
}
