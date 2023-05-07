<#
.SYNOPSIS
Sends a text or binary response body to the HTTP listener client.

.INPUTS
System.String containing the text to return to the HTTP client.

.LINK
https://docs.microsoft.com/dotnet/api/system.net.httplistener

.EXAMPLE
Write-WebResponse.ps1 $httpContext.Response 'Success'

Sends the string "Success" to the HTTP listener client as text/plain.

.EXAMPLE
ConvertTo-Json $data |Write-WebResponse.ps1 $httpContext.Response -ContentType application/json

Sends the JSON data to the HTTP listener client.
#>

#Requires -Version 3
[CmdletBinding()] Param(
# An HTTP response object to write the response to.
[Parameter(Position=0,Mandatory=$true)][Net.HttpListenerResponse] $Response,
# Text to send in the response.
[Parameter(ParameterSetName='Text',Position=1,ValueFromPipeline=$true)][string] $Text,
# The media type of the response.
[string] $ContentType = 'text/plain',
# The text encoding to use in the response.
[Parameter(ParameterSetName='Text')][Text.Encoding] $Encoding = [Text.Encoding]::UTF8,
# Binary data to send in the response.
[Parameter(ParameterSetName='Binary')][Alias('BinaryData','Data')][byte[]] $Bytes,
# Name of a file containing binary data to send in the response.
[Parameter(ParameterSetName='File')][string] $Path
)
$readbytes =
	if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=$true}}
	else {@{Encoding='Byte'}}
if($Text) {[byte[]]$Bytes = $Encoding.GetBytes($Text)}
elseif($Path) {[byte[]]$Bytes = Get-Content $Path @readbytes}
$Response.OutputStream.Write($Bytes,0,$Bytes.Length)
$Response.Close()
