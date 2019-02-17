<#
.Synopsis
    Gets elements from a web response by tag name.

.Parameter TagName
    The name of elements to return all occurrences of.

.Parameter Response
    The Invoke-WebRequest output to parse.

.Inputs
    Microsoft.PowerShell.Commands.HtmlWebResponseObject to parse elements from.

.Link
    Invoke-WebRequest

.Example
    Invoke-WebRequest https://www.h2g2.com/ -UseBasicParsing:$false |Get-Html.ps1 title |select text

    text
    ----
    h2g2 - The Guide to Life, The Universe and Everything

.Example
    Invoke-WebRequest https://http.cat/ -UseBasicParsing:$false |Get-Html.ps1 script |measure |select Count

    Count
    -----
        5
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][Alias('ElementName')][string]$TagName,
[Parameter(Position=1,ValueFromPipeline=$true)]
[Microsoft.PowerShell.Commands.HtmlWebResponseObject]$Response
)
Process
{
    if(!$Response.ParsedHtml)
    {throw "$($MyInvocation.MyCommand.Name) requires -UseBasicParsing input to be false."}
    Write-Verbose "Reading $TagName elements from '$($response.ParsedHtml.title)'"
    $response.ParsedHtml.getElementsByTagName($TagName)
}
