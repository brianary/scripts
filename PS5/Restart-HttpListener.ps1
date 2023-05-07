<#
.SYNOPSIS
Stops and restarts an HTTP listener.

.INPUTS
System.Net.HttpListener to stop and restart.

.LINK
Start-HttpListener.ps1

.LINK
Stop-HttpListener.ps1

.LINK
https://docs.microsoft.com/dotnet/api/system.net.httplistener

.EXAMPLE
Restart-HttpListener.ps1 $http

The $http listener is stopped and restarted.
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The HTTP listener to stop and restart.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Net.HttpListener] $Listener
)
Stop-HttpListener.ps1 $Listener
Start-HttpListener.ps1 $Listener

