<#
.SYNOPSIS
Sends an event (often an error) from a script to a Seq server, including script info.

.PARAMETER Action
A description of what was being attempted.

.PARAMETER ErrorRecord
An optional PowerShell ErrorRecord object to record.
Will try to automatically find $_ in a calling "catch{}"" block.

.PARAMETER Level
The type of event to record.
Defaults to Error if an ErrorRecord is found, Information otherwise.

.PARAMETER InvocationScope
The scope of the script InvocationInfo to use.
Defaults to 1 (the script calling Send-SeqScriptEvent.ps1).
Sending a 2 will try to use the script calling the script calling this one.

.PARAMETER Server
The URL of the Seq server.

.PARAMETER ApiKey
The Seq API key to use.

.LINK
Send-SeqEvent.ps1

.LINK
https://getseq.net/

.EXAMPLE
try { Connect-Thing } catch { Send-SeqScriptEvent.ps1 'Trying to connect' $_ -Level Error -Server http://my-seq }
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
[Parameter(Position=0,Mandatory=$true)][string]$Action,
[Parameter(Position=1)][Management.Automation.ErrorRecord]$ErrorRecord =
    ((Get-Variable _ -Scope 1 -ValueOnly -EA SilentlyContinue) -as [Management.Automation.ErrorRecord]),
[Parameter(Position=2)][ValidateSet('Verbose','Debug','Information','Warning','Error','Fatal')][string] $Level = 'Error',
[Alias('Scope')][string] $InvocationScope = '1',
[uri] $Server,
[string] $ApiKey
)

if(!($ErrorRecord -or $PSBoundParameters.ContainsKey('Level'))) { $Level = 'Information' }
$caller = try{Get-Variable MyInvocation -Scope $InvocationScope -ValueOnly -EA Stop}catch{$MyInvocation}
$SeqEvent = @{ Level = $Level }
if($Server){[void]$SeqEvent.Add('Server',$Server)}
if($ApiKey){[void]$SeqEvent.Add('ApiKey',$ApiKey)}
$Properties = @{
    Script       = if($caller.ScriptName){Split-Path $caller.ScriptName -Leaf}else{$caller.MyCommand.Name}
    CommandName  = $caller.MyCommand.Name
    Invocation   = $caller
    Action       = $Action
    CommandLine  = [Environment]::GetCommandLineArgs()
    ComputerName = $env:COMPUTERNAME
}
if($ErrorRecord)
{
    $Properties += @{
        Message     = $ErrorRecord.Exception.Message
        Error       = $ErrorRecord
    }
    [void]$SeqEvent.Add('Message','{Script}: {Action}: {Message}')
}
else
{
    [void]$SeqEvent.Add('Message','{Script}: {Action}')
}
[void]$SeqEvent.Add('Properties',$Properties)
Send-SeqEvent.ps1 @SeqEvent
