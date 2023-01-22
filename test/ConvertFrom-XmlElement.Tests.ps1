<#
.SYNOPSIS
Tests Converts named nodes of an element to properties of a PSObject, recursively.
#>

Describe 'ConvertFrom-XmlElement' -Tag ConvertFrom-XmlElement {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$datadir = Join-Path $PSScriptRoot .. 'test','data'
		$ScriptName = Join-Path $scriptsdir ConvertFrom-XmlElement.ps1
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
	Context 'Converts named nodes of an element to properties of a PSObject, recursively' `
		-Tag ConvertFromXmlElement,Convert,ConvertFrom,XmlElement,Xml {
		It "Should convert from an XML document to an object" {
			$xmlfile = Join-Path $datadir test.xml
			$doc = [xml](Get-Content $xmlfile -Raw) |
				ConvertFrom-XmlElement.ps1
			$doc |Should -BeOfType pscustomobject
			$value = $doc.'ConvertFrom-XmlElement.ps1'
			$value |Should -BeOfType pscustomobject
			$value.Functionality |Should -BeExactly XML
			$value.Synopsis |Should -BeExactly 'Converts named nodes of an element to properties of a PSObject, recursively.'
			$value.Size |Should -BeExactly 3436
			$value.Lines |Should -BeExactly 98
			$value.Name |Should -BeExactly 'ConvertFrom-XmlElement.ps1'
			$value.Hash |Should -BeOfType pscustomobject
			$value.Hash.SHA256 |Should -BeExactly 'E0CD4B1D6BE201EDEFE38F3A868A18624E18CC9280B4BBC10F57BE84BA15A64A'
		}
		It "Should convert from an XML element to an object" {
			$xmlfile = Join-Path $datadir test.xml
			$doc = [xml](Get-Content $xmlfile -Raw)
			$doc |Should -BeOfType xml
			$value = $doc.DocumentElement.ChildNodes |
				Where-Object Name -eq 'ConvertFrom-XmlElement.ps1' |
				ConvertFrom-XmlElement.ps1
			$value |Should -BeOfType pscustomobject
			$value.Functionality |Should -BeExactly XML
			$value.Synopsis |Should -BeExactly 'Converts named nodes of an element to properties of a PSObject, recursively.'
			$value.Size |Should -BeExactly 3436
			$value.Lines |Should -BeExactly 98
			$value.Name |Should -BeExactly 'ConvertFrom-XmlElement.ps1'
			$value.Hash |Should -BeOfType pscustomobject
			$value.Hash.SHA256 |Should -BeExactly 'E0CD4B1D6BE201EDEFE38F3A868A18624E18CC9280B4BBC10F57BE84BA15A64A'
		}
		It "Should convert the XML from Select-Xml into an object" {
			$xmlfile = Join-Path $datadir test.xml
			$value = Select-Xml "/Scripts/Script[Name='ConvertFrom-XmlElement.ps1']" -Path $xmlfile |
				ConvertFrom-XmlElement.ps1
			$value |Should -BeOfType pscustomobject
			$value.Functionality |Should -BeExactly XML
			$value.Synopsis |Should -BeExactly 'Converts named nodes of an element to properties of a PSObject, recursively.'
			$value.Size |Should -BeExactly 3436
			$value.Lines |Should -BeExactly 98
			$value.Name |Should -BeExactly 'ConvertFrom-XmlElement.ps1'
			$value.Hash |Should -BeOfType pscustomobject
			$value.Hash.SHA256 |Should -BeExactly 'E0CD4B1D6BE201EDEFE38F3A868A18624E18CC9280B4BBC10F57BE84BA15A64A'
		}
	}
}
