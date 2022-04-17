<#
.SYNOPSIS
Set the default Server and ApiKey for Send-SeqEvent.ps1

.PARAMETER Server
The URL of the Seq server.

.PARAMETER ApiKey
The Seq API key to use.

.LINK
https://getseq.net/

.EXAMPLE
Use-SeqServer.ps1 http://my-seq $apikey
#>

#requires -Version 4
[CmdletBinding()][OutputType([void])] Param(
[Parameter(Mandatory=$true)][uri] $Server,
[string] $ApiKey
)

Write-Verbose "Using Seq at $Server"
$value = @{
    'Send-SeqEvent.ps1:Server' = $Server
    'Send-SeqEvent.ps1:ApiKey' = $ApiKey
}
$defaults = Get-Variable -Scope 1 -Name PSDefaultParameterValues -EA SilentlyContinue
if($defaults) {$value.Keys |? {$defaults.Value.Contains($_)} |% {$defaults.Value.Remove($_)}; $defaults.Value += $value}
else {Set-Variable -Scope 1 -Name PSDefaultParameterValues -Value $value}
