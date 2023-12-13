<#
.SYNOPSIS
When run within a Polyglot Notebook, appends a cell to it.

.PARAMETER Language
The cell language to use.

.FUNCTIONALITY
Notebooks

.INPUTS
Any object that can be converted to a string and used as cell content.

.EXAMPLE
"flowchart LR`nA --> B" |Add-NotebookCell.ps1 mermaid

Appends a cell with a Mermaid chart.
#>

#Requires -Version 7
using namespace Microsoft.DotNet.Interactive
using namespace Microsoft.DotNet.Interactive.Commands
[CmdletBinding()] Param(
# The cell content.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][psobject] $InputObject
)
DynamicParam
{
	try {[Kernel]::Root.ChildKernels.Name |Add-DynamicParam.ps1 Language string}
	catch {'csharp','fsharp','html','http','javascript','kql','mermaid','pwsh','sql','value','vscode' |Add-DynamicParam.ps1 Language string}
	$DynamicParams
}
End
{
	if(!$PSBoundParameters.ContainsKey('Language'))
	{
		[Kernel]::Root.SendAsync((New-Object SendEditableCode 'vscode',($input |Out-String))) |Out-Null
	}
	else
	{
		[Kernel]::Root.SendAsync((New-Object SendEditableCode $PSBoundParameters['Language'],($input |Out-String))) |Out-Null
	}
}
