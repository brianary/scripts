<#
.SYNOPSIS
Listens on a given port of the localhost, returning the body of a single web request, and responding with an empty 204.

.LINK
Start-HttpListener.ps1

.LINK
Stop-HttpListener.ps1

.LINK
Receive-WebRequest.ps1

.LINK
Read-WebRequest.ps1

.EXAMPLE
Get-WebRequestBody.ps1

(Returns the body of one request to http://localhost:8080/ as a byte array.)
#>

#Requires -Version 3
[CmdletBinding()][OutputType([byte[]])] Param(
# The local port to listen on.
[int] $Port = 8080
)
$http = Start-HttpListener.ps1 -Port $Port
$context = Receive-WebRequest.ps1 $http
$context.Request.Headers.Keys |foreach {Write-Verbose "${_}: $($context.Request.Headers[$_])"}
$readbytes =
	if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=$true}}
	else {@{Encoding='Byte'}}
Read-WebRequest.ps1 $context.Request @readbytes
$context.Response.StatusCode = 204
$context.Response.Close()
Stop-HttpListener.ps1 $http

