<#
.SYNOPSIS
Parses TSV clipboard data into HTML table data which is copied back to the clipboard.

.FUNCTIONALITY
Clipboard

.EXAMPLE
Convert-ClipboardTsvToHtml.ps1

TSV clipboard data may now be pasted into an email or document as a table.
#>

#Requires -Version 3
[CmdletBinding()] Param()

if($PSVersionTable.PSEdition -ne 'Desktop')
{
	Invoke-WindowsPowerShell.ps1 { Convert-ClipboardTsvToHtml.ps1 }
}
else
{
	Import-ClipboardTsv.ps1 |
		ConvertTo-Html -Fragment |
		ConvertTo-SafeEntities.ps1 |
		Set-Clipboard -AsHtml
}

