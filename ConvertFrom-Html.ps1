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
    switch($TableElement.tagName)
    {
        table
        {
            $rows,$cols = $TableElement.rows.length,$TableElement.rows[0].cells.length
            Write-Verbose "Table contains $cols columns, $rows rows"
            $i,$max,$act = 0,($TableElement.rows.length/100),"Reading '$($TableElement.document.title)' ${cols}x$rows table"
            $headers = $TableElement.rows[0].cells |% {$_.innerText -replace '\s+',' ' -replace '\A\s+|\s+\z',''}
            1..($rows-1) |% {$TableElement.rows[$_]} -pv row |% {
                $value = [ordered]@{}
                0..($cols-1) |% {$value[$headers[$_]]= $row.cells[$_].innerText}
                $object = [pscustomobject]$value
                Write-Progress $act (ConvertTo-Json $object -Compress) -PercentComplete ($i++/$max)
                $object
            }
            Write-Progress $act -Completed
        }
        default {throw "Unable to convert from HTML <$($TableElement.tagName.ToLower())> element."}
    }
}
