<#
.Synopsis
    Stops and restarts an HTTP listener.

.Parameter Listener
    The HTTP listener to stop and restart.

.Inputs
    System.Net.HttpListener to stop and restart.

.Link
    Start-HttpListener.ps1

.Link
    Stop-HttpListener.ps1

.Link
	https://docs.microsoft.com/dotnet/api/system.net.httplistener

.Example
    Restart-HttpListener.ps1 $http

    The $http listener is stopped and restarted.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Net.HttpListener] $Listener
)
Stop-HttpListener.ps1 $Listener
Start-HttpListener.ps1 $Listener
