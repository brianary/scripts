<#
.SYNOPSIS
Listens for an HTTP request and returns an HTTP request & response.

.INPUTS
System.Net.HttpListener to receive the request through.

.OUTPUTS
System.Net.HttpListenerContext containing the Request and the Response that can be used to reply.

.LINK
https://docs.microsoft.com/dotnet/api/system.net.httplistener

.EXAMPLE
$context = Receive-WebRequest.ps1 $http

Accepts an HTTP request returns it in an HTTP context object.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Net.HttpListenerContext])] Param(
# The HTTP listener to receive the request through.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Net.HttpListener] $Listener
)
if(!$Listener.IsListening) {Write-Warning 'The HTTP listener is not listening.'}
$Listener.GetContext()
