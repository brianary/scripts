<#
.Synopsis
	Listens for an HTTP request and returns an HTTP request & response.

.Parameter Listener
	The HTTP listener to receive the request through.

.Inputs
	System.Net.HttpListener to receive the request through.

.Outputs
	System.Net.HttpListenerContext containing the Request and the Response that can be used to reply.

.Link
	https://docs.microsoft.com/dotnet/api/system.net.httplistener

.Example
    $context = Receive-WebRequest.ps1 $http

    Accepts an HTTP request returns it in an HTTP context object.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Net.HttpListenerContext])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Net.HttpListener] $Listener
)
if(!$Listener.IsListening) {Write-Warning 'The HTTP listener is not listening.'}
$Listener.GetContext()
