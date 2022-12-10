<#
.SYNOPSIS
Tests adding a dynamic parameter to a DynamicParam object.
#>

Describe 'Add-DynamicParam' -Tag Add-DynamicParam {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-DynamicParam.ps1" -Severity Warning |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-DynamicParam.ps1" -Severity Error |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly $null -Because 'there should be no style errors'
		}
	}
	Context 'Adding parameters' {
		It "Adds a required string parameter" {
			Add-DynamicParam.ps1 -Name Path -Type string -Mandatory
			$DynamicParams.Count |Should -Be 1
			$DynamicParams.Keys |Should -Contain Path
			$DynamicParams['Path'].ParameterType |Should -Be string
			$DynamicParams['Path'].Attributes.Count |Should -Be 1
			$DynamicParams['Path'].Attributes[0].ParameterSetName |Should -BeExactly __AllParameterSets
			$DynamicParams['Path'].Attributes[0].Mandatory |Should -BeTrue
			$DynamicParams['Path'].Attributes[0].ValueFromPipeline |Should -BeFalse
			$DynamicParams['Path'].Attributes[0].ValueFromPipelineByPropertyName |Should -BeFalse
			$DynamicParams['Path'].Attributes[0].ValueFromRemainingArguments |Should -BeFalse
		}
		It "Adds several alternative parameters" {
			Add-DynamicParam.ps1 -Name Document -Type Xml.XmlDocument -ParameterSetName Document `
				-Position 0 -Mandatory -ValueFromPipeline
			Add-DynamicParam.ps1 -Name Element -Type Xml.XmlElement -Parameter Element `
				-Position 0 -Mandatory -ValueFromPipeline
			Add-DynamicParam.ps1 -Name SelectXmlInfo -Type Microsoft.PowerShell.Commands.SelectXmlInfo `
				-ParameterSetName SelectXmlInfo -Position 0 -Mandatory -ValueFromPipeline
			$DynamicParams.Count |Should -Be 3
			$DynamicParams.Keys |Should -Contain Document
			$DynamicParams['Document'].ParameterType |Should -Be xml
			$DynamicParams['Document'].Attributes.Count |Should -Be 1
			$DynamicParams['Document'].Attributes[0].ParameterSetName |Should -BeExactly Document
			$DynamicParams['Document'].Attributes[0].Position |Should -BeExactly 0
			$DynamicParams['Document'].Attributes[0].Mandatory |Should -BeTrue
			$DynamicParams['Document'].Attributes[0].ValueFromPipeline |Should -BeTrue
			$DynamicParams['Document'].Attributes[0].ValueFromPipelineByPropertyName |Should -BeFalse
			$DynamicParams['Document'].Attributes[0].ValueFromRemainingArguments |Should -BeFalse
			$DynamicParams.Keys |Should -Contain Element
			$DynamicParams['Element'].ParameterType |Should -Be System.Xml.XmlElement
			$DynamicParams['Element'].Attributes.Count |Should -Be 1
			$DynamicParams['Element'].Attributes[0].ParameterSetName |Should -BeExactly Element
			$DynamicParams['Element'].Attributes[0].Position |Should -BeExactly 0
			$DynamicParams['Element'].Attributes[0].Mandatory |Should -BeTrue
			$DynamicParams['Element'].Attributes[0].ValueFromPipeline |Should -BeTrue
			$DynamicParams['Element'].Attributes[0].ValueFromPipelineByPropertyName |Should -BeFalse
			$DynamicParams['Element'].Attributes[0].ValueFromRemainingArguments |Should -BeFalse
			$DynamicParams.Keys |Should -Contain SelectXmlInfo
			$DynamicParams['SelectXmlInfo'].ParameterType |Should -Be Microsoft.PowerShell.Commands.SelectXmlInfo
			$DynamicParams['SelectXmlInfo'].Attributes.Count |Should -Be 1
			$DynamicParams['SelectXmlInfo'].Attributes[0].ParameterSetName |Should -BeExactly SelectXmlInfo
			$DynamicParams['SelectXmlInfo'].Attributes[0].Position |Should -BeExactly 0
			$DynamicParams['SelectXmlInfo'].Attributes[0].Mandatory |Should -BeTrue
			$DynamicParams['SelectXmlInfo'].Attributes[0].ValueFromPipeline |Should -BeTrue
			$DynamicParams['SelectXmlInfo'].Attributes[0].ValueFromPipelineByPropertyName |Should -BeFalse
			$DynamicParams['SelectXmlInfo'].Attributes[0].ValueFromRemainingArguments |Should -BeFalse
		}
	}
	AfterEach {
		Remove-Variable -Name DynamicParam -Force -ErrorAction Ignore
	}
}
