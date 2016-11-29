<#
.Synopsis
    Right-aligns numeric data in an HTML table for emailing, with some additional styling options.

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

.Link
    https://www.campaignmonitor.com/css/

.Example
    Invoke-Sqlcmd "..." |ConvertFrom-DataRow.ps1 |ConvertTo-Html |Format-HtmlDataTable.ps1
    Runs the query, parses each row into an HTML row, then fixes the alignment of numeric cells.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0)][string]$Caption,
[Parameter(Position=1)][string]$OddRowBackground,
[Parameter(Position=2)][string]$EvenRowBackground,
[Alias('TableAtts')][string]$TableAttributes = 'cellpadding="2" cellspacing="0" style="font:x-small ''Lucida Console'',monospace"',
[Alias('CaptionAtts','CapAtts')][string]$CaptionAttributes = 'style="font:bold small serif;border:1px inset #DDD;padding:1ex 0;background:#FFF"',
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
    $Html = $Html -replace '<td>(\(\p{Sc}?\d+(?:[., ]\d+)*\)|(?:[-−﹣－+＋±]\p{Sc}|[-−﹣－+＋±]?\p{Sc}?)\d+(?:[., ]\d+)*[\p{Sc}%‰‱]?)</td>','<td align="right">$1</td>'
    if($Html -like '*<table>*')
    {
        if($Caption) {$Html = $Html -replace '<table>',"<table><caption $CaptionAttributes>$([Net.WebUtility]::HtmlEncode($Caption))</caption>"}
        if($TableAttributes) {$Html = $Html -replace '<table>',"<table $TableAttributes>"}
    }
    $odd = !$odd
    if($odd -and $OddRowBackground) {$Html -replace '^<tr>',"<tr style=`"background:$OddRowBackground`">"}
    elseif(!$odd -and $EvenRowBackground) {$Html -replace '^<tr>',"<tr style=`"background:$EvenRowBackground`">"}
    else {$Html}
}