<#
.Synopsis
    Send an event to a Seq server.

.Parameter Message
    The text to use as the log message, a Seq template unless -LiteralMessage is present.
    By default, the value of the Message property will be used.

.Parameter Properties
    A hashtable of structured logging properties to record in Seq.

.Parameter Level
    The type of event to record.
    Information by default.

.Parameter Server
    The URL of the Seq server.

.Parameter ApiKey
    The Seq API key to use.

.Parameter LiteralMessage
    When present, indicates the Message parameter is to be used verbatim, not as a Seq template.

.Link
    Invoke-RestMethod

.Link
    https://getseq.net/

.Example
    Send-SeqEvent.ps1 'Hello from PowerShell' -Server http://my-seq -LiteralMessage

.Example
    Send-SeqEvent.ps1 'Event: {User} on {Machine}' @{ User = $env:UserName; Machine = $env:ComputerName } -Server http://my-seq

.Example
    Send-SeqEvent.ps1 -Properties @{ Message = $Error[0].Exception.Message } -Level Error -Server http://my-seq
#>

#requires -Version 4
[CmdletBinding()] Param(
[Parameter(Position=0)][Alias('Text')][string] $Message = '{Message}',
[Parameter(Mandatory=$true,Position=1)][Alias('Parameters')][hashtable] $Properties,
[ValidateSet('Verbose','Debug','Information','Warning','Error','Fatal')][string] $Level = 'Information',
[uri] $Server,
[string] $ApiKey,
[switch] $LiteralMessage
)

if($LiteralMessage) { $Properties += @{Message=$Message}; $Message = "{Message}" }

@{
    Uri         = New-Object uri ([uri]$Server,"/api/events/raw?apiKey=$ApiKey")
    Method      = 'POST'
    ContentType = 'application/json'
    Body        = @{
        Events  = @(
            @{
                Timestamp       = Get-Date -Format o
                Level           = $Level
                MessageTemplate = $Message
                Properties      = $Properties
            }
        )
    } |ConvertTo-Json -Depth 5 -Compress
} |% {Invoke-RestMethod @_}
