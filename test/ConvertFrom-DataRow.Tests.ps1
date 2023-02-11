<#
.SYNOPSIS
Tests Converts a DataRow object to a PSObject, Hashtable, or single value.
#>

Describe 'ConvertFrom-DataRow' -Tag ConvertFrom-DataRow {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$datadir = Join-Path $PSScriptRoot .. 'test','data'
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Converts a DataRow object to a PSObject, Hashtable, or single value' `
		-Tag ConvertFromDataRow,Convert,ConvertFrom,DataRow {
		BeforeAll {
			$data = New-Object Data.DataSet
			[void]$data.ReadXml((Join-Path $datadir 'product-dataset.xml'))
		}
		It "Should convert rows to objects" {
			$rows = $data.Tables['Product'] |ConvertFrom-DataRow.ps1
			$rows |Should -BeOfType pscustomobject
			$rows.ProductID |Should -BeExactly 1,2,3,4
			$rows.Name |Should -BeExactly 'Widget','Gimmick','Gadget','Contrivance'
		}
		It "Should convert rows to dictionaries" {
			$rows = $data.Tables['Product'] |ConvertFrom-DataRow.ps1 -AsDictionary
			$rows |Should -BeOfType Collections.Specialized.OrderedDictionary
			$rows.ProductID |Should -BeExactly 1,2,3,4
			$rows.Name |Should -BeExactly 'Widget','Gimmick','Gadget','Contrivance'
		}
		It "Should convert rows to values" {
			$rows = $data.Tables['Product'] |ConvertFrom-DataRow.ps1 -AsValues
			$rows |Should -BeOfType pscustomobject
			$rows |Should -BeExactly 1,'Widget',2,'Gimmick',3,'Gadget',4,'Contrivance'
		}
	}
}
