<#
.SYNOPSIS
Tests adding a NoteProperty to a PSObject, calculating the value with the object in context.
#>

Describe 'Add-NoteProperty' -Tag Add-NoteProperty {
	BeforeAll {
		if(!(Get-Module -List PSScriptAnalyzer)) {Install-Module PSScriptAnalyzer -Force}
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Script style' -Tag Style {
		It "Should follow best practices for style" {
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-NoteProperty.ps1" -Severity Warning |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly '' -Because 'there should be no style warnings'
			Invoke-ScriptAnalyzer -Path "$PSScriptRoot\..\Add-NoteProperty.ps1" -Severity Error |
				ForEach-Object {$_.Severity,$_.ScriptName,$_.Line,$_.Column,$_.RuleName,$_.Message -join ':'} |
				Should -BeExactly '' -Because 'there should be no style errors'
		}
	}
	Context 'Add a calculated property value' -Tag NoteProperty {
		It "Should add a property with a static value calculated when added" {
			$value = [pscustomobject]@{x=8} |Add-NoteProperty.ps1 pow {[math]::Log2($_.x)} -PassThru
			$value.x = 16 # this should not change the pow property
			$value.pow |Should -Be 3
		}
	}
}
