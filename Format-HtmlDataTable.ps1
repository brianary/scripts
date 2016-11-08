<#
.Synopsis
    Right-aligns numeric data in an HTML table for emailing, and optionally zebra-stripes &c.

.Parameter OddRowBackground
    The background CSS value for odd rows.

.Parameter EvenRowBackground
    The background CSS value for even rows.

.Parameter TableAttributes
    Any table attributes desired (cellpadding, cellspacing, style, &c.).

.Parameter Html
    The HTML table data to be piped in.

.Inputs
    System.String (HTML, as produced by ConvertTo-Html)

.Outputs
    System.String (data-formatted HTML)

.Note
    Assumes only one <tr> element per string piped in, as produced by ConvertTo-Html.

.Link
    ConvertTo-Html

.Link
    https://www.w3.org/Bugs/Public/show_bug.cgi?id=18026

.Example
    Invoke-Sqlcmd "..." |ConvertFrom-DataRow.ps1 |ConvertTo-Html |Format-HtmlDataTable.ps1
    Runs the query, parses each row into an HTML row, then fixes the alignment of numeric cells.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0)][string]$OddRowBackground,
[Parameter(Position=1)][string]$EvenRowBackground,
[string]$TableAttributes = 'cellpadding="2" cellspacing="0" style="font:x-small ''Lucida Console'',monospace"',
[Parameter(ValueFromPipeline=$true)][string]$Html
)
Begin
{
    $odd = $false
    if($OddRowBackground) {$OddRowBackground = [Net.WebUtility]::HtmlEncode($OddRowBackground) -replace '"','&quot;'}
    if($EvenRowBackground) {$EvenRowBackground = [Net.WebUtility]::HtmlEncode($EvenRowBackground) -replace '"','&quot;'}
}
Process
{
    $odd = !$odd
    $Html = $Html -replace '<td>(-?\d+(\.\d+)?)</td>','<td align="right">$1</td>'
    if($TableAttributes) {$Html = $Html -replace '<table>',"<table $TableAttributes>"}
    if($odd -and $OddRowBackground) {$Html -replace '^<tr>',"<tr style=`"background:$OddRowBackground`">"}
    elseif(!$odd -and $EvenRowBackground) {$Html -replace '^<tr>',"<tr style=`"background:$EvenRowBackground`">"}
    else {$Html}
}