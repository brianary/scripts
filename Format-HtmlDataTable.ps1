<#
.SYNOPSIS
Right-aligns numeric data in an HTML table for emailing, and optionally zebra-stripes &c.

.INPUTS
System.String containing an HTML table, as produced by ConvertTo-Html.

.OUTPUTS
System.String containing the data-formatted HTML table.

.NOTES
Assumes only one <tr> element per string piped in, as produced by ConvertTo-Html.

.LINK
ConvertTo-Html

.LINK
https://www.w3.org/Bugs/Public/show_bug.cgi?id=18026

.EXAMPLE
Invoke-Sqlcmd "..." |ConvertFrom-DataRow.ps1 |ConvertTo-Html |Format-HtmlDataTable.ps1

Runs the query, parses each row into an HTML row, then fixes the alignment of numeric cells.

.EXAMPLE
$rows |ConvertTo-Html -Fragment |Format-HtmlDataTable.ps1 'Products' '#F99' '#FFF'

Renders DataRows as an HTML table, right-aligns numeric cells, then adds a caption ("Products"),
and alternates the rows between pale yellow and white.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
# The HTML table caption, a label for the table.
[Parameter(Position=0)][string]$Caption,
# The background CSS value for odd rows.
[Parameter(Position=1)][string]$OddRowBackground,
# The background CSS value for even rows.
[Parameter(Position=2)][string]$EvenRowBackground,
# Any table attributes desired (cellpadding, cellspacing, style, &c.).
[Alias('TableAtts')][string]$TableAttributes = 'cellpadding="2" cellspacing="0" style="font:x-small ''Lucida Console'',monospace"',
# HTML attributes for the table caption.
[Alias('CaptionAtts','CapAtts')][string]$CaptionAttributes = 'style="font:bold small serif;border:1px inset #DDD;padding:1ex 0;background:#FFF"',
# Applies a standard .NET formatting pattern to numbers, such as N or '#,##0.000;(#,##0.000);zero'.
[string]$NumericFormat,
# The HTML table data to be piped in.
[Parameter(ValueFromPipeline=$true)][string]$Html
)
Begin
{
    $odd = $false
    if($OddRowBackground) {$OddRowBackground = [Security.SecurityElement]::Escape($OddRowBackground)}
    if($EvenRowBackground) {$EvenRowBackground = [Security.SecurityElement]::Escape($EvenRowBackground)}
}
Process
{
    $odd = !$odd
	$Html =
		if($NumericFormat)
		{
			[regex]::Replace($Html,'<td>([-$]?)(\d+(?:,\d{3})*(?:\.\d+)?)</td>',
				{
					Param($match)
					'<td align="right">',$match.Groups[1].Value,
						([decimal]$match.Groups[2].Value).ToString($NumericFormat),'</td>' -join ''
				})
		}
		else {$Html -replace '<td>([-$]?\d+(?:,\d{3})*(?:\.\d+)?)</td>','<td align="right">$1</td>'}
    if($Html -like '*<table>*')
    {
        if($Caption) {$Html = $Html -replace '<table>',"<table><caption $CaptionAttributes>$([Security.SecurityElement]::Escape($Caption))</caption>"}
        if($TableAttributes) {$Html = $Html -replace '<table>',"<table $TableAttributes>"}
    }
    if($odd -and $OddRowBackground) {$Html -replace '^<tr>',"<tr style=`"background:$OddRowBackground`">"}
    elseif(!$odd -and $EvenRowBackground) {$Html -replace '^<tr>',"<tr style=`"background:$EvenRowBackground`">"}
    else {$Html}
}
