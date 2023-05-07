<#
.SYNOPSIS
Send an event to a Seq server.

.INPUTS
System.Collections.Hashtable
or System.Collections.Specialized.OrderedDictionary
or System.Data.DataRow
or an object

.FUNCTIONALITY
Seq

.LINK
Invoke-RestMethod

.LINK
https://getseq.net/

.EXAMPLE
Send-SeqEvent.ps1 'Hello from PowerShell' -Server http://my-seq -LiteralMessage

.EXAMPLE
Send-SeqEvent.ps1 'Event: {User} on {Machine}' @{ User = $env:UserName; Machine = $env:ComputerName } -Server http://my-seq

.EXAMPLE
Send-SeqEvent.ps1 -Properties @{ Message = $Error[0].Exception.Message } -Level Error -Server http://my-seq
#>

#requires -Version 4
[CmdletBinding()][OutputType([void])] Param(
<#
The text to use as the log message, a Seq template unless -LiteralMessage is present.
By default, the value of the Message property will be used.
#>
[Parameter(Position=0)][Alias('Text')][string] $Message = '{Message}',
<#
Logging properties to record in Seq, as an OrderedDictionary, Hashtable, DataRow,
or any object with properties to use.
#>
[Parameter(Mandatory=$true,Position=1,ValueFromPipeline=$true)][Alias('Parameters')] $Properties,
<#
The type of event to record.
Information by default.
#>
[ValidateSet('Verbose','Debug','Information','Warning','Error','Fatal')][string] $Level = 'Information',
# The URL of the Seq server.
[uri] $Server,
# The Seq API key to use.
[string] $ApiKey,
# When present, indicates the Message parameter is to be used verbatim, not as a Seq template.
[switch] $LiteralMessage
)
Process
{
    if($Properties -is [hashtable]) {}
    elseif($Properties -is [Collections.Specialized.OrderedDictionary]) {}
    elseif($Properties -is [Data.DataRow]) {$Properties = ConvertFrom-DataRow.ps1 $Properties -AsHashtable}
    else {$Properties = ConvertTo-OrderedDictionary.ps1 $Properties}

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
    } |ForEach-Object {Invoke-RestMethod @_ |Write-Verbose}
}

