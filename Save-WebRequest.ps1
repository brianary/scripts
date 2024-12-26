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

using namespace System.Net.Mime
#Requires -Version 7
[CmdletBinding()][OutputType([void])] Param(
# The URL to download.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('Url','Href','Src')][uri] $Uri,
# The directory to save the file into.
[string] $OutDirectory,
# Sets the creation time on the file to the given value.
[datetime] $CreationTime,
# Sets the creation time on the file to the given value.
[datetime] $LastWriteTime,
# When present, invokes the file after it is downloaded.
[switch] $Open
)
Begin
{
	$Script:BadFileNameCharClass = $IsLinux ? "[\0\a\b\t\r\v\f\n\e\\/?*`"]" :
		"[$(([IO.Path]::GetInvalidFileNameChars() |ForEach-Object {'\u{0:X4}' -f ([int]$_)}) -join '')]"

	function Get-ValidFileName
	{
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(Position=0)][string] $FileName
		)
		return ($FileName -replace '(\A.*[\\/])?') -replace $Script:BadFileNameCharClass
	}

	function Get-FileName
	{
		[CmdletBinding()][OutputType([string])] Param(
		[Parameter(Position=0)][uri] $Uri
		)
		$uriFilename, $suggestion = $null, $null
		$response = Invoke-WebRequest $Uri -Method Head -SkipHttpErrorCheck -MaximumRedirection 0 -AllowInsecureRedirect -EA Ignore
		if([int]::DivRem($response.StatusCode, 100).Item1 -eq 3 -and $response.Headers['Location'].Count -gt 0)
		{
			return Get-FileName (New-Object uri $Uri,($response.Headers['Location'][0]))
		}
		if($response.Headers['Content-Disposition'].Count -gt 0)
		{
			[ContentDisposition] $disposition = $response.Headers['Content-Disposition'][0]
			$suggestion = $disposition.FileName
		}
		if($suggestion) {return Get-ValidFileName $suggestion}
		elseif($null -ne $Uri.Segments -and $Uri.Segments.Count -gt 0) {return Get-ValidFileName ($Uri.Segments[-1])}
		elseif($Uri.Host) {return Get-ValidFileName ('{0}.saved' -f $Uri.Host)}
		else {return Get-ValidFileName "$Uri.saved"}
	}
}
Process
{
	$filename = Get-FileName $Uri
	if($OutDirectory) {$filename = Join-Path $OutDirectory $filename}
	$response = Invoke-WebRequest $Uri -OutFile $filename -PassThru
	if($PSBoundParameters.ContainsKey('CreationTime')) {(Get-Item $filename).CreationTime = $CreationTime}
	if($PSBoundParameters.ContainsKey('LastWriteTime')) {(Get-Item $filename).LastWriteTime = $LastWriteTime}
	elseif($response.Headers['Last-Modified'].Count -gt 0)
	{
		(Get-Item $filename).LastWriteTime = [datetimeoffset]::Parse(($response.Headers['Last-Modified'][0])).LocalDateTime
	}
	if($Open) {Invoke-Item $filename}
}
