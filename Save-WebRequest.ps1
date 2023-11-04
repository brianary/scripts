<#
.SYNOPSIS
Downloads a given URL to a file, automatically determining the filename.

.INPUTS
Object with System.Uri property named Uri.

.FUNCTIONALITY
HTTP

.LINK
https://tools.ietf.org/html/rfc2183

.LINK
http://test.greenbytes.de/tech/tc2231/

.LINK
https://msdn.microsoft.com/library/system.net.mime.contentdisposition.filename.aspx

.LINK
https://msdn.microsoft.com/library/system.io.path.getinvalidfilenamechars.aspx

.LINK
Invoke-WebRequest

.LINK
Invoke-Item

.LINK
Move-Item

.EXAMPLE
Save-WebRequest.ps1 https://www.irs.gov/pub/irs-pdf/f1040.pdf -Open

Saves f1040.pdf (or else a filename specified in the Content-Disposition header) and opens it.
#>

[CmdletBinding()][OutputType([void])] Param(
# The URL to download.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('Url','Href','Src')][uri] $Uri,
# Sets the creation time on the file to the given value.
[datetime] $CreationTime,
# Sets the creation time on the file to the given value.
[datetime] $LastWriteTime,
# When present, invokes the file after it is downloaded.
[switch] $Open
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
	if($PSBoundParameters.ContainsKey('CreationTime')) {(Get-Item $filename).CreationTime = $CreationTime}
	if($PSBoundParameters.ContainsKey('LastWriteTime')) {(Get-Item $filename).LastWriteTime = $LastWriteTime}
	if($Open) {Invoke-Item $filename}
}
