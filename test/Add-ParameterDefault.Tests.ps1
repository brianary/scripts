<#
.SYNOPSIS
Tests appending or creating a value to use for the specified cmdlet parameter to use when one is not specified.
#>

Describe 'Add-ParameterDefault' -Tag Add-ParameterDefault {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Add-ParameterDefault.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Appends or creates a value to use for the specified cmdlet parameter to use when one is not specified.' `
		-Tag AddParameterDefault,Add,ParameterDefault {
		It "Should set a simple default" {
			Add-ParameterDefault.ps1 epcsv nti $true -Scope Global
			$PSDefaultParameterValues.ContainsKey('Export-Csv:NoTypeInformation') |
				Should -BeTrue -Because 'defaults should be added after looking up cmdlet and param aliases'
			$PSDefaultParameterValues['Export-Csv:NoTypeInformation'] |Should -BeTrue
		}
		It "Should set a hashtable default" {
			Add-ParameterDefault.ps1 Select-Xml Namespace @{svg = 'http://www.w3.org/2000/svg'}
			$PSDefaultParameterValues.ContainsKey('Select-Xml:Namespace') |Should -BeTrue
			$PSDefaultParameterValues['Select-Xml:Namespace'].ContainsKey('svg') |Should -BeTrue
			$PSDefaultParameterValues['Select-Xml:Namespace']['svg'] |Should -BeExactly 'http://www.w3.org/2000/svg'
		}
	}
}
