<#
.Synopsis
	Parses an HTTP listener request.

.Parameter Request
	The HTTP listener to receive the request through.

.Parameter Encoding
	Forces an encoding for the request body; Byte for binary, others for text.

.Link
	https://docs.microsoft.com/dotnet/api/system.net.httplistener

.Example
    Read-WebRequest.ps1 $httpContext.Request

    Parses the request body as a string or byte array.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Net.HttpListenerRequest] $Request,
[ValidateSet('ascii','byte','utf16','utf16BE','utf32','utf32BE','utf7','utf8')][string] $Encoding
)

function Read-BinaryWebRequest
{
	if(!$Request.HasEntityBody) {return}
	if(!$Request.InputStream.CanRead)
	{Stop-ThrowError.ps1 InvalidOperationException 'Unable to read HTTP request.' InvalidOperation $Request NOREAD}
	if($Request.ContentLength64 -lt 1)
	{
		$read = 0
		[byte[]] $data = New-Object byte[] 1KB
		do
		{
			if($read -gt 0) {[array]::Resize([ref]$data,$data.Length*2)}
			$read += $Request.InputStream.Read($data,$read,$data.Length - $read)
		}
		while($read -eq $data.Length)
		[array]::Resize([ref]$data,$read)
	}
	else
	{
		[byte[]] $data = New-Object byte[] $Request.ContentLength64
		if(!$Request.InputStream.Read($data,0,$data.Length))
		{Stop-ThrowError.ps1 InvalidOperationException 'No data read from HTTP request.' InvalidOperation $Request ZEROREAD}
	}
	,$data
}

function Read-TextWebRequest([Text.Encoding] $Encoding = $Request.ContentEncoding)
{
    $Encoding.GetString((Read-BinaryWebRequest))
}

$Request.Headers |Out-String |Write-Verbose
if($Encoding)
{
	if($Encoding -eq 'byte') {Read-BinaryWebRequest}
	else {Read-TextWebRequest ([Text.Encoding]::GetEncoding(($Encoding -replace '^utf','utf-')))}
}
else
{
	#TODO: multipart/alternative, multipart/parallel, multipart/related, multipart/form-data, multipart/*
	# https://stackoverflow.com/a/21689347/54323
	# https://docs.microsoft.com/dotnet/api/system.net.http.streamcontent
	$texty = '\A(?:(?:text|message)/.*|application/(?:json|(?:.*\+)xml))\z'
	if(([Net.Mime.ContentType]$Request.ContentType).MediaType -match $texty) {Read-TextWebRequest}
	else {Read-BinaryWebRequest}
}
