<#
.Synopsis
    Set the default Server and ApiKey for Send-SeqEvent.ps1

.Parameter Server
    The URL of the Seq server.

.Parameter ApiKey
    The Seq API key to use.

.Link
    https://getseq.net/

.Example
    Use-SeqServer.ps1 http://my-seq $apikey
#>

#requires -Version 4
[CmdletBinding()] Param(
[Parameter(Mandatory=$true)][uri] $Server,
[string] $ApiKey
)

Set-Variable PSDefaultParameterValues @{ 'Send-SeqEvent.ps1:Server' = $Server; 'Send-SeqEvent.ps1:ApiKey' = $ApiKey } -Scope 1
