<#
.Synopsis
    Downloads a given URL to a file, automatically determining the filename.

.Parameter Uri
    The URL to download.

.Parameter Open
	When present, invokes the file after it is downloaded.

.Inputs
	Object with System.Uri property named Uri.

.Link
    https://tools.ietf.org/html/rfc2183

.Link
    http://test.greenbytes.de/tech/tc2231/

.Link
    https://msdn.microsoft.com/library/system.net.mime.contentdisposition.filename.aspx

.Link
    https://msdn.microsoft.com/library/system.io.path.getinvalidfilenamechars.aspx

.Link
    Invoke-WebRequest

.Link
    Invoke-Item

.Link
    Move-Item

.Example
    Save-WebRequest.ps1 https://www.irs.gov/pub/irs-pdf/f1040.pdf -Open

    Saves f1040.pdf (or else a filename specified in the Content-Disposition header) and opens it.
#>

[CmdletBinding()][OutputType([void])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][uri]$Uri,
[switch]$Open
)
Begin
{
    function Get-ValidFileName([string]$filename)
    {($filename -replace '(\A.*[\\/])?','').Split([IO.Path]::GetInvalidFileNameChars()) -join ''}
}
Process
{
    $filename = Get-ValidFileName $Uri.Segments[-1]
    $response = Invoke-WebRequest $Uri -OutFile $filename -PassThru
    if(([Collections.IDictionary]$response.Headers).Contains('Content-Disposition'))
    {
        [Net.Mime.ContentDisposition]$disposition = $response.Headers['Content-Disposition']
        $suggestedFilename = Get-ValidFileName $disposition.FileName
        if($filename -cne $suggestedFilename) {Move-Item $filename $suggestedFilename; $filename = $suggestedFilename}
    }
    if($Open) {Invoke-Item $filename}
}
