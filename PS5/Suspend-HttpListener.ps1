﻿<#
.SYNOPSIS
Pauses an HTTP listener.

.INPUTS
System.Net.HttpListener to pause.

.LINK
https://docs.microsoft.com/dotnet/api/system.net.httplistener

.EXAMPLE
Suspend-HttpListener.ps1 $http

The $http listener is paused.
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The HTTP listener to pause.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Net.HttpListener] $Listener
)
$Listener.Stop()
$Listener |Out-String |Write-Verbose
