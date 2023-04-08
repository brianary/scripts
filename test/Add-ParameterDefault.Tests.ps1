<#
.SYNOPSIS
Tests appending or creating a value to use for the specified cmdlet parameter to use when one is not specified.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Add-ParameterDefault' -Tag Add-ParameterDefault -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
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
