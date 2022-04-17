<#
.SYNOPSIS
Closes an HTTP listener.

.PARAMETER Listener
The HTTP listener to close.

.INPUTS
System.Net.HttpListener to close.

.LINK
https://docs.microsoft.com/dotnet/api/system.net.httplistener

.EXAMPLE
Stop-HttpListener.ps1 $http

The $http listener is closed.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Net.HttpListener] $Listener
)
$Listener.Close()
$Listener |Out-String |Write-Verbose
