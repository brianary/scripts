<#
.SYNOPSIS
Sends an event (often an error) from a script to a Seq server, including script info.

.LINK
Send-SeqEvent.ps1

.LINK
https://getseq.net/

.EXAMPLE
try { Connect-Thing } catch { Send-SeqScriptEvent.ps1 'Trying to connect' $_ -Level Error -Server http://my-seq }
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
# A description of what was being attempted.
[Parameter(Position=0,Mandatory=$true)][string]$Action,
<#
An optional PowerShell ErrorRecord object to record.
Will try to automatically find $_ in a calling "catch{}"" block.
#>
[Parameter(Position=1)][Management.Automation.ErrorRecord]$ErrorRecord =
    ((Get-Variable _ -Scope 1 -ValueOnly -EA SilentlyContinue) -as [Management.Automation.ErrorRecord]),
<#
The type of event to record.
Defaults to Error if an ErrorRecord is found, Information otherwise.
#>
[Parameter(Position=2)][ValidateSet('Verbose','Debug','Information','Warning','Error','Fatal')][string] $Level = 'Error',
<#
The scope of the script InvocationInfo to use.
Defaults to 1 (the script calling Send-SeqScriptEvent.ps1).
Sending a 2 will try to use the script calling the script calling this one.
#>
[Alias('Scope')][string] $InvocationScope = '1',
# The URL of the Seq server.
[uri] $Server,
# The Seq API key to use.
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
