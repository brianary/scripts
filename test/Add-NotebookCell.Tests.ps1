<#
.SYNOPSIS
Tests running within a Polyglot Notebook, appending a cell to it.
#>

$basename = "$(($MyInvocation.MyCommand.Name -split '\.',2)[0])."
$skip = !(Test-Path .changes -Type Leaf) ? $false :
	!@(Get-Content .changes |Get-Item |Select-Object -ExpandProperty Name |Where-Object {$_.StartsWith($basename)})
if($skip) {Write-Information "No changes to $basename" -infa Continue}
Describe 'Add-NotebookCell' -Tag Add-NotebookCell -Skip:$skip {
	BeforeAll {
		$scriptsdir,$sep = (Split-Path $PSScriptRoot),[io.path]::PathSeparator
		if($scriptsdir -notin ($env:Path -split $sep)) {$env:Path += "$sep$scriptsdir"}
		$mockfile = Join-Path $PSScriptRoot mock ([io.path]::ChangeExtension((Split-Path $PSCommandPath -Leaf), 'cs'))
		try {[void][Kernel]}
		catch {Add-Type -TypeDefinition (Get-Content $mockfile -Raw)}
	}
	Context 'When run within a Polyglot Notebook, appends a cell to it' -Tag AddNoteboodCell,Add,NotebookCell,Notebook {
		It "Adding language '<Language>' code '<Code>' should happen" -TestCases @(
			@{ Language = 'sql'; Code = "select * from products;" }
			@{ Language = 'mermaid'; Code = "flowchart LR`nA -->B" }
		) {
			Param([string] $Language, [string] $Code)
			$Code |Add-NotebookCell.ps1 -Language $Language
			[Kernel]::Root.Sent.Language |Should -BeExactly $Language
			[Kernel]::Root.Sent.Content.TrimEnd() |Should -BeExactly $Code
		}
	}
}
