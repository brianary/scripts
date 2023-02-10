<#
.SYNOPSIS
Tests adding a dynamic parameter to a DynamicParam object.
#>

Describe 'Add-DynamicParam' -Tag Add-DynamicParam {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Add-DynamicParam.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Adding parameters' -Tag AddDynamicParam,Add,'DynamicParam' {
		It "Should add a required string parameter" {
			Add-DynamicParam.ps1 -Name Path -Type string -Mandatory
			$DynamicParams.Count |Should -Be 1 -Because 'one should have been added'
			$DynamicParams.Keys |Should -Contain Path -Because 'the right one should have been added'
			$DynamicParams['Path'].ParameterType |Should -Be string -Because 'it should be the right type'
			$DynamicParams['Path'].Attributes.Count |Should -Be 1 -Because 'one attribute should exist'
			$DynamicParams['Path'].Attributes[0].ParameterSetName |Should -BeExactly __AllParameterSets -Because 'the parameter set should be the default'
			$DynamicParams['Path'].Attributes[0].Mandatory |Should -BeTrue -Because 'it should be required'
			$DynamicParams['Path'].Attributes[0].ValueFromPipeline |Should -BeFalse -Because 'it shouldn''t accept values from the pipeline'
			$DynamicParams['Path'].Attributes[0].ValueFromPipelineByPropertyName |Should -BeFalse -Because 'it shouldn''t accept the property from the pipeline'
			$DynamicParams['Path'].Attributes[0].ValueFromRemainingArguments |Should -BeFalse -Because 'it shouldn''t accept the rest of the unnamed params'
		}
		It "Should add several alternative parameters" {
			Add-DynamicParam.ps1 -Name Document -Type Xml.XmlDocument -ParameterSetName Document `
				-Position 0 -Mandatory -ValueFromPipeline
			Add-DynamicParam.ps1 -Name Element -Type Xml.XmlElement -Parameter Element `
				-Position 0 -Mandatory -ValueFromPipeline
			Add-DynamicParam.ps1 -Name SelectXmlInfo -Type Microsoft.PowerShell.Commands.SelectXmlInfo `
				-ParameterSetName SelectXmlInfo -Position 0 -Mandatory -ValueFromPipeline
			$DynamicParams.Count |Should -Be 3 -Because 'three should''ve been added'
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
