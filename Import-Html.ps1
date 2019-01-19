<#
.Synopsis
    Imports from an HTML table's rows, given a URL.

.Parameter Uri
    The URL to read the HTML from.

.Parameter TableIndex
    Which table to import, by the element's document position.

.Link
    Invoke-WebRequest

.Example
    Import-Html.ps1 https://www.irs.gov/e-file-providers/foreign-country-code-listing-for-modernized-e-file

    Country Name                        Country Code
    ------------                        ------------
    Afghanistan                         AF
    Akrotiri                            AX
    Albania                             AL
    Algeria                             AG
    …
#>

[CmdletBinding()] Param(
[Parameter(Mandatory=$true,Position=0,ValueFromPipelineByPropertyName=$true)][uri]$Uri,
[Parameter(Position=1,ValueFromPipelineByPropertyName=$true)]
[Alias('Index','Position','Number')][int]$TableIndex = 0
)
Process
{
    $response = Invoke-WebRequest $Uri -UseBasicParsing:$false
    $response.ParsedHtml.getElementsByTagName('table')[$TableIndex] |ConvertFrom-Html.ps1
}
