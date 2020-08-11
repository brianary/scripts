<#
.Synopsis
	Sends a text or binary response body to the HTTP listener client.

.Parameter Listener
    The HTTP listener response object to send content to the client through.

.Inputs
	System.String containing the text to return to the HTTP client.

.Link
	https://docs.microsoft.com/dotnet/api/system.net.httplistener

.Example
    Write-WebResponse.ps1 $httpContext.Response 'Success'

    Sends the string "Success" to the HTTP listener client as text/plain.

.Example
    ConvertTo-Json $data |Write-WebResponse.ps1 $httpContext.Response -ContentType application/json

    Sends the JSON data to the HTTP listener client.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][Net.HttpListenerResponse] $Response,
[Parameter(ParameterSetName='Text',Position=2,ValueFromPipeline=$true)][string] $Text,
[string] $ContentType = 'text/plain',
[Parameter(ParameterSetName='Text')][Text.Encoding] $Encoding = [Text.Encoding]::UTF8,
[Parameter(ParameterSetName='Binary')][Alias('BinaryData','Data')][byte[]] $Bytes,
[Parameter(ParameterSetName='File')][string] $Path
)
$readbytes =
	if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=$true}}
	else {@{Encoding='Byte'}}
if($Text) {[byte[]]$Bytes = $Encoding.GetBytes($Text)}
elseif($Path) {[byte[]]$Bytes = Get-Content $Path @readbytes}
$Response.OutputStream.Write($Bytes,0,$Bytes.Length)
$Response.Close()
