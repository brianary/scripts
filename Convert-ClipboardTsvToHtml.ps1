<#
.Synopsis
	Parses TSV clipboard data into HTML table data which is copied back to the clipboard.

.Example
	Convert-ClipboardTsvToHtml.ps1

	TSV clipboard data may now be pasted into an email or document as a table.
#>

#Requires -Version 3
[CmdletBinding()] Param()
Import-ClipboardTsv.ps1 |
	ConvertTo-Html -Fragment |
	Set-Clipboard -AsHtml
