<#
.Synopsis
    Imports from an HTML table's rows, given a URL.

.Parameter Uri
    The URL to read the HTML from.

.Parameter TableIndex
    Which table to import, by the element's document position (zero-based).

.Inputs
	Objects with one or more of these properties:

		* System.Uri named Uri
		* System.UInt32 named TableIndex

.Outputs
	System.__ComObject containing the parsed element COM object.

.Link
    ConvertFrom-Html.ps1

.Link
    Get-Html.ps1

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

[CmdletBinding()][OutputType([__ComObject])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][uri]$Uri,
[Parameter(Position=1,ValueFromPipelineByPropertyName=$true)]
[Alias('Index','Position','Number')][uint32]$TableIndex = 0
)
Process
{
    Invoke-WebRequest $Uri -UseBasicParsing:$false |
        Get-Html.ps1 table |
        select -Skip $TableIndex -First 1 |
        ConvertFrom-Html.ps1
}
