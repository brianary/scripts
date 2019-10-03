<#
.Synopsis
    Pauses an HTTP listener.

.Parameter Listener
    The HTTP listener to pause.

.Inputs
    System.Net.HttpListener to pause.

.Link
	https://docs.microsoft.com/dotnet/api/system.net.httplistener

.Example
    Suspend-HttpListener.ps1 $http

    The $http listener is paused.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Net.HttpListener] $Listener
)
$Listener.Stop()
$Listener |Out-String |Write-Verbose
