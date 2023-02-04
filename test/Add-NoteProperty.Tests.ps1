<#
.SYNOPSIS
Tests adding a NoteProperty to a PSObject, calculating the value with the object in context.
#>

Describe 'Add-NoteProperty' -Tag Add-NoteProperty {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		$ScriptName = Join-Path $scriptsdir Add-NoteProperty.ps1
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Comment-based help' -Tag CommentHelp {
		It "Should produce help object" {
			Get-Help $ScriptName |Should -Not -BeOfType string `
				-Because 'Get-Help should not fall back to the default help string'
		}
	}
	Context 'Add a calculated property value' -Tag AddNoteProperty,Add,NoteProperty {
		It "Should add a property with a static value calculated when added" {
			$value = [pscustomobject]@{x=8} |Add-NoteProperty.ps1 pow {[math]::Log2($_.x)} -PassThru
			$value.x = 16 # this should not change the pow property
			$value.pow |Should -Be 3 -Because 'the pow property value should have been determined only when added'
		}
	}
}
