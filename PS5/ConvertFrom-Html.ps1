<#
.Synopsis
    Parses an HTML table into objects.

.Parameter TableElement
    The HTML table, as parsed by Invoke-WebRequest without -UseBasicParsing enabled,
    within the ParsedHtml property.

.Inputs
	A __ComObject contained within an Invoke-WebRequest response's ParsedHtml document.

.Outputs
	System.Management.Automation.PSCustomObject for each table row.

.Link
    Invoke-WebRequest

.Example
    $r = Invoke-WebRequest $url ; $r.ParsedHtml.getElementsByTagName('table')[0] |ConvertFrom-Html.ps1

	Returns objects parsed from the first HTML table at $url, assuming the first row is a header.

.Example
	Invoke-WebRequest https://www.federalreserve.gov/aboutthefed/k8.htm -UseBasicParsing:$false |Get-Html.ps1 table |ConvertFrom-Html.ps1 |Format-Table -Auto

	Column_1                            2020        2021         2022          2023         2024
	--------                            ----        ----         ----          ----         ----
	New Year's Day                      January 1   January 1    January 1*    January 1**  January 1
	Birthday of Martin Luther King, Jr. January 20  January 18   January 17    January 16   January 15
	Washington's Birthday               February 17 February 15  February 21   February 20  February 19
	Memorial Day                        May 25      May 31       May 30        May 29       May 27
	Independence Day                    July 4*     July 4**     July 4        July 4       July 4
	Labor Day                           September 7 September 6  September 5   September 4  September 2
	Columbus Day                        October 12  October 11   October 10    October 9    October 14
	Veterans Day                        November 11 November 11  November 11   November 11* November 11
	Thanksgiving Day                    November 26 November 25  November 24   November 23  November 28
	Christmas Day                       December 25 December 25* December 25** December 25  December 25
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)][__ComObject] $TableElement
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
			$headers = $TableElement.rows[0].cells |
				foreach {$_.innerText -replace '\s+',' ' -replace '\A\s+|\s+\z',''} |
				foreach {++$i;if([string]::IsNullOrWhiteSpace($_)){"Column_$($i)"}else{$_}}
			$i = 0
            1..($rows-1) |foreach {$TableElement.rows[$_]} -pv row |foreach {
                $value = [ordered]@{}
                0..($cols-1) |foreach {$value[$headers[$_]]= $row.cells[$_].innerText}
                $object = [pscustomobject]$value
                Write-Progress $act (ConvertTo-Json $object -Compress) -PercentComplete ($i++/$max)
                $object
            }
            Write-Progress $act -Completed
        }
        default {throw "Unable to convert from HTML <$($TableElement.tagName.ToLower())> element."}
    }
}
