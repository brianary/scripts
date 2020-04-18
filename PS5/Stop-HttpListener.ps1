<#
.Synopsis
    Closes an HTTP listener.

.Parameter Listener
    The HTTP listener to close.

.Inputs
    System.Net.HttpListener to close.

.Link
	https://docs.microsoft.com/dotnet/api/system.net.httplistener

.Example
    Stop-HttpListener.ps1 $http

    The $http listener is closed.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Net.HttpListener] $Listener
)
$Listener.Close()
$Listener |Out-String |Write-Verbose
