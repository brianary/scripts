<#
.Synopsis
	Parses an HTTP listener request.

.Parameter Request
    The HTTP listener to receive the request through.

.Link
	https://docs.microsoft.com/dotnet/api/system.net.httplistener

.Example
    Read-WebRequest.ps1 $httpContext.Request

    Parses the request body as a string or byte array.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Net.HttpListenerRequest] $Request
)

function Read-BinaryWebRequest
{
    [byte[]] $data = New-Object byte[] $Request.ContentLength64
    if(!$Request.InputStream.Read($data,0,$data.Length))
    {Stop-ThrowError.ps1 InvalidOperationException 'No data read from HTTP request.' InvalidOperation $Request ZEROREAD}
    ,$data
}

function Read-TextWebRequest
{
    $Request.ContentEncoding.GetString((Read-BinaryWebRequest))
}

$Request.Headers |Out-String |Write-Verbose
if(!$Request.HasEntityBody) {return}
if(!$Request.ContentLength64) {Write-Warning 'Empty HTTP request body.'; return}
if(!$Request.InputStream.CanRead)
{Stop-ThrowError.ps1 InvalidOperationException 'Unable to read HTTP request.' InvalidOperation $Request NOREAD}
#TODO: multipart/alternative, multipart/parallel, multipart/related, multipart/form-data, multipart/*
# https://stackoverflow.com/a/21689347/54323
# https://docs.microsoft.com/dotnet/api/system.net.http.streamcontent
if(([Net.Mime.ContentType]$Request.ContentType).MediaType -match '\A(?:(?:text|message)/.*|application/(?:json|(?:.*\+)xml))\z') {Read-TextWebRequest}
else {Read-BinaryWebRequest}
