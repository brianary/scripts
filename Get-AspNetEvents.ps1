<#
.Synopsis
Parses ASP.NET errors from the event log on the given server.
.Parameter ComputerName
The name of the server on which the error occurred.
.Parameter EntryType
Gets only events with the specified entry type. Valid values are Error, Information, and Warning. The default is all events.
.Parameter After
Skip events older than this datetime.
.Parameter Before
Skip events newer than this datetime.
.Parameter Newest
The maximum number of the most recent events to return.
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Mandatory=$true,Position=0)][Alias('CN','Server')][string[]]$ComputerName,
[ValidateSet('Information','Warning','Error')][string[]]$EntryType,
[DateTime]$After,
[DateTime]$Before,
[int]$Newest
)
$FieldNames= @(
    @('EventCode','EventMessage','EventTime','EventTimeUtc','EventId','EventSequence','EventOccurrence',
        'EventDetailCode','AppDomain','TrustLevel','AppPath','AppLocalPath','MachineName','_','ProcessId','ProcessName',
        'AccountName','ExceptionType','ExceptionMessage','RequestUrl','RequestPath','UserHostAddress','User','IsAuthenticated',
        'AuthenticationType','ReqThreadAccountName','ThreadId','ThreadAccountName','IsImpersonating','StackTrace','CustomEventDetails'),
    @('EventCode','EventMessage','EventTime','EventTimeUtc','EventId','EventSequence','EventOccurrence',
        'EventDetailCode','AppDomain','TrustLevel','AppPath','AppLocalPath','MachineName','_','ProcessId','ProcessName',
        'AccountName','RequestUrl','RequestPath','UserHostAddress','User','IsAuthenticated','AuthenticationType',
        'ThreadAccountName','CustomEventDetails')
) |sort Length
$RemoveFields= '_','ThreadAccountName','ReqThreadAccountName' # blank or redundant fields
$BoolFields= 'IsAuthenticated','IsImpersonating'
$IntFields= 'EventOccurrence','EventSequence','EventCode','EventDetailCode','ProcessId','ThreadId'
$EventQuery = @{
    ComputerName = $ComputerName
    LogName      = 'Application'
    Source       = 'ASP.NET 4.0.30319.0','ASP.NET 2.0.50727.0','ASP.NET 1.1.4322.0'
}
if($After){$EventQuery.After=$After}
if($Before){$EventQuery.Before=$Before}
if($Newest){$EventQuery.Newest=$Newest}
if($EntryType){$EventQuery.EntryType=$EntryType}
Get-EventLog @EventQuery |
    ? {1017,1019,1023,1025 -notcontains $_.EventID} | # don't want ASP.NET registration events
    % {
        [string]$type = $_.EntryType
        $fields = @{EntryType=$type;Source=$_.Source;EventTime=$_.TimeGenerated}
        if($type -eq 'Error')
        { # errors aren't structured nicely
            if($_.Message -match '(?m)^Application ID: (?.+)$'){$fields.AppId=$Matches.AppId.TrimEnd()}
            if($_.Message -match '(?m)^Process ID: (?.+)$'){$fields.ProcessId=[int]$Matches.ProcessId.TrimEnd()}
            if($_.Message -match '(?m)^Exception: (\w+\.)*(?\w+)\s*$'){$fields.ExceptionType=$Matches.ExceptionType}
            if($_.Message -match '(?m)^Message: (?.+)$'){$fields.ExceptionMessage=$Matches.ExceptionMessage.TrimEnd()}
            if($_.Message -match '(?ms)^StackTrace: (?.+)$'){$fields.StackTrace=$Matches.StackTrace.TrimEnd()}
        }
        elseif($_.ReplacementStrings.Length)
        {
            $values = $_.ReplacementStrings
            $names = $FieldNames |? Length -ge $values.Length |select -f 1
            if($values.Length -gt $names.Length) { Write-Warning ('Unexpected field values: {0} > {1}' -f $values.Length,$names.Length) }
            for($i=0; $i -lt $values.Length; $i++) {$fields[$names[$i]]= $values[$i].TrimEnd()}
            $RemoveFields |% {$fields.Remove($_)}
            $BoolFields |% {$fields[$_]=[bool]$fields[$_]}
            $IntFields |% {$fields[$_]=[int]$fields[$_]}
            $fields.RequestUrl= [uri]$fields.RequestUrl
            $fields.EventTime= [datetime]::Parse($fields.EventTime,$null,[Globalization.DateTimeStyles]::AssumeLocal)
            $fields.EventTimeUtc= [datetime]::Parse($fields.EventTimeUtc,$null,[Globalization.DateTimeStyles]::AssumeUniversal)
            if($fields.ExceptionMessage -and $fields.StackTrace)
            { $fields.ExceptionMessage= $fields.ExceptionMessage.Replace($fields.StackTrace,'').TrimEnd() } # don't need stack trace twice
        }
        $event = New-Object PSObject -p $fields
        $event.PSObject.TypeNames.Insert(0,'AspNetApplicationEventLogEntry')
        $event
    }