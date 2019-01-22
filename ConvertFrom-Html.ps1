<#
.Synopsis
    Parses an HTML table into objects.

.Parameter TableElement
    The HTML table, as parsed by Invoke-WebRequest without -UseBasicParsing enabled,
    within the ParsedHtml property.

.Inputs
    A __ComObject contained within an Invoke-WebRequest response's ParsedHtml document.

.Link
    Invoke-WebRequest

.Example
    $r = Invoke-WebRequest $url ; $r.ParsedHtml.getElementsByTagName('table')[0] |ConvertFrom-Html.ps1

    Returns objects parsed from the first HTML table at $url, assuming the first row is a header.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][__ComObject]$TableElement
)
Process
{
    Write-Verbose "Table contains $($TableElement.rows.length) rows"
    $i,$max = 0,($TableElement.rows.length/100)
    $headers = $TableElement.rows[0].cells |% {$_.innerText -replace '\s+',' ' -replace '\A\s+|\s+\z',''}
    1..($TableElement.rows.length-1) |% {$TableElement.rows[$_]} -pv row |% {
        $value = [ordered]@{}
        0..($row.cells.length-1) |% {$value[$headers[$_]]= $row.cells[$_].innerText}
        $object = [pscustomobject]$value
        Write-Progress 'Reading rows' "{$(ConvertTo-Json $object -Compress)}" -PercentComplete ($i++/$max)
        $object
    }
}
