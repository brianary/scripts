<#
.SYNOPSIS
Tests Converts named nodes of an element to properties of a PSObject, recursively.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'ConvertFrom-XmlElement' -Tag ConvertFrom-XmlElement -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$datadir = Join-Path $PSScriptRoot 'data'
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
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
