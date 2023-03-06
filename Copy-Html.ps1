<#
.SYNOPSIS
Copies objects as an HTML table.

.INPUTS
System.Management.Automation.PSObject to be turned into a table row.

.LINK
Format-HtmlDataTable.ps1

.LINK
ConvertTo-SafeEntities.ps1

.LINK
Invoke-WindowsPowerShell.ps1

.EXAMPLE
Get-PSDrive |Copy-Html.ps1 Name,Description

Copies an HTML table with two columns to the clipboard as formatted text
that can be pasted into emails or other formatted documents.
#>

#Requires -Version 7
[CmdletBinding()][OutputType([void])] Param(
# Columns to include in the copied table.
[Parameter(Position=0)][array] $Property,
# The objects to turn into table rows.
[Parameter(ValueFromPipeline=$true)][psobject] $InputObject
)
Begin
{
	$data = @()
}
Process
{
	$data += $InputObject
}
End
{
	$data |
		Select-Object -Property $Property |
		ConvertTo-Html -Fragment |
		Format-HtmlDataTable.ps1 |
		ConvertTo-SafeEntities.ps1 |
		Out-String |
		Set-Clipboard
	Invoke-WindowsPowerShell.ps1 { Get-Clipboard |Set-Clipboard -AsHtml }
}
