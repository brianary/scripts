<#
.SYNOPSIS
Tests adding a NoteProperty to a PSObject, calculating the value with the object in context.
#>

Describe 'Add-NoteProperty' -Tag Add-NoteProperty {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Add a calculated property value' -Tag AddNoteProperty,Add,NoteProperty {
		It "Should add a property with a static value calculated when added" {
			$value = [pscustomobject]@{x=8} |Add-NoteProperty.ps1 pow {[math]::Log2($_.x)} -PassThru
			$value.x = 16 # this should not change the pow property
			$value.pow |Should -Be 3 -Because 'the pow property value should have been determined only when added'
		}
	}
}
