<#
.SYNOPSIS
Tests Converts a DataRow object to a PSObject, Hashtable, or single value.
#>

if((Test-Path .changes -Type Leaf) -and
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |
		Where-Object {$_.StartsWith("$(($MyInvocation.MyCommand.Name -split '\.',2)[0]).")})) {return}
BeforeAll {
	Set-StrictMode -Version Latest
	$module = Get-Item "$PSScriptRoot/../src/.publish/*.psd1"
	Import-Module $module -Force
}
Describe 'ConvertFrom-DataRow' -Tag ConvertFrom-DataRow {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$datadir = Join-Path $PSScriptRoot 'data'
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Converts a DataRow object to a PSObject, Hashtable, or single value' `
		-Tag ConvertFromDataRow,Convert,ConvertFrom,DataRow {
		BeforeAll {
			$data = New-Object Data.DataSet
			[void]$data.ReadXml((Join-Path $datadir 'product-dataset.xml'))
		}
		It "Should convert rows to objects" {
			$rows = $data.Tables['Product'] |ConvertFrom-DataRow
			$rows |Should -BeOfType pscustomobject
			$rows.ProductID |Should -BeExactly 1,2,3,4
			$rows.Name |Should -BeExactly 'Widget','Gimmick','Gadget','Contrivance'
		}
		It "Should convert rows to dictionaries" {
			$rows = $data.Tables['Product'] |ConvertFrom-DataRow -AsDictionary
			$rows |Should -BeOfType Collections.Specialized.OrderedDictionary
			$rows.ProductID |Should -BeExactly 1,2,3,4
			$rows.Name |Should -BeExactly 'Widget','Gimmick','Gadget','Contrivance'
		}
		It "Should convert rows to values" {
			$rows = $data.Tables['Product'] |ConvertFrom-DataRow -AsValues
			$rows |Should -BeOfType pscustomobject
			$rows |Should -BeExactly 1,'Widget',2,'Gimmick',3,'Gadget',4,'Contrivance'
		}
	}
}
AfterAll {
	Remove-Module $module.BaseName -Force
}
