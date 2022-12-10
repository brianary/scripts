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
	Context 'Appends or creates a value to use for the specified cmdlet parameter to use when one is not specified.' -Tag Example {
		It "Setting a simple default" {
			Add-ParameterDefault.ps1 epcsv nti $true -Scope Global
			$PSDefaultParameterValues.ContainsKey('Export-Csv:NoTypeInformation') |
				Should -BeTrue -Because 'defaults should be added after looking up cmdlet and param aliases'
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
