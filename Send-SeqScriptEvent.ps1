<#
.Synopsis
    Sends an event from a script to a Seq server, including script info.

.Parameter Action
    A description of what was being attempted.

.Parameter ErrorRecord
    An optional PowerShell ErrorRecord object to record.

.Parameter Level
    The type of event to record.
    Information by default.

.Parameter InvocationScope
    The scope of the script InvocationInfo to use.
    Defaults to 1 (the script calling Send-SeqScriptEvent.ps1).
    Sending a 2 will try to use the script calling the script calling this one.

.Parameter Server
    The URL of the Seq server.

.Parameter ApiKey
    The Seq API key to use.

.Link
    Send-SeqEvent.ps1

.Link
    https://getseq.net/

.Example
    try { Connect-Thing } catch { Send-SeqScriptEvent.ps1 'Trying to connect' $_ -Level Error -Server http://my-seq }
#>

#requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string]$Action,
[Parameter(Position=1)][Management.Automation.ErrorRecord]$ErrorRecord,
[Parameter(Position=2)][ValidateSet('Verbose','Debug','Information','Warning','Error','Fatal')][string] $Level = 'Information',
[Alias('Scope')][string] $InvocationScope = '1',
[uri] $Server,
[string] $ApiKey
)
$caller = try{Get-Variable MyInvocation -Scope $Scope -ValueOnly -EA Stop}catch{$MyInvocation}
$SeqEvent = @{ Level = $Level }
if($Server){[void]$SeqEvent.Add('Server',$Server)}
if($ApiKey){[void]$SeqEvent.Add('ApiKey',$ApiKey)}
$Properties = @{
    Script      = $caller.MyCommand.Name
    Line        = $caller.Line
    Column      = $caller.OffsetInLine
    Action      = $Action
    CommandLine = [Environment]::GetCommandLineArgs()
}
if($Error)
{
    $Properties += @{
        Message     = $ErrorRecord.Exception.Message
        Error       = $ErrorRecord
    }
    [void]$SeqEvent.Add('Message','{Script}:{Line}:{Column}: {Action}: {Message}')
}
else
{
    [void]$SeqEvent.Add('Message','{Script}:{Line}:{Column}: {Action}')
}
[void]$SeqEvent.Add('Properties',$Properties)
Send-SeqEvent.ps1 @SeqEvent
