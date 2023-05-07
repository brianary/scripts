<#
.SYNOPSIS
Set the default Server and ApiKey for Send-SeqEvent.ps1

.FUNCTIONALITY
Seq

.LINK
https://getseq.net/

.EXAMPLE
Use-SeqServer.ps1 http://my-seq $apikey
#>

#requires -Version 4
[CmdletBinding()][OutputType([void])] Param(
# The URL of the Seq server.
[Parameter(Mandatory=$true)][uri] $Server,
# The Seq API key to use.
[string] $ApiKey
)

Write-Verbose "Using Seq at $Server"
$value = @{
    'Send-SeqEvent.ps1:Server' = $Server
    'Send-SeqEvent.ps1:ApiKey' = $ApiKey
}
$defaults = Get-Variable -Scope 1 -Name PSDefaultParameterValues -EA SilentlyContinue
if($defaults) {$value.Keys |Where-Object {$defaults.Value.Contains($_)} |ForEach-Object {$defaults.Value.Remove($_)}; $defaults.Value += $value}
else {Set-Variable -Scope 1 -Name PSDefaultParameterValues -Value $value}
