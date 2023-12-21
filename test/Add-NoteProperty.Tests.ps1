<#
.SYNOPSIS
Tests adding a NoteProperty to a PSObject, calculating the value with the object in context.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Add-NoteProperty' -Tag Add-NoteProperty -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
	}
	Context 'Add a calculated property value' -Tag AddNoteProperty,Add,NoteProperty {
		It "Should add a property with a static value calculated when added" {
			$value = [pscustomobject]@{x=8} |Add-NoteProperty.ps1 bits {[math]::Log2($_.x)} -PassThru
			$value.x = 16 # this should not change the pow property
			$value.bits |Should -Be 3 -Because 'the bits property value should have been determined only when added'
		}
		It "Should add multiple properties with a mix of value types" {
			$value = [pscustomobject]@{x=8} |Add-NoteProperty.ps1 @{
				bits = {[math]::Log2($_.x)}
				binary = {'{0:b}' -f $_.x}
				isNumeric = $true
			} -PassThru
			$value.x = 16 # this should not change the pow property
			$value.bits |Should -Be 3 -Because 'the bits property value should be statically evaluated'
			$value.binary |Should -Be '1000' -Because 'the binary property should be statically evaluated'
			$value.isNumeric |Should -BeTrue -Because 'the isNumeric property should be true'
		}
	}
}
