<#
.Synopsis
    Parses ASP.NET errors from the event log on the given server.

.Parameter ComputerName
    The name of the server on which the error occurred.

.Parameter After
    Skip events older than this datetime.
    Defaults to 00:00 today.

.Parameter Before
    Skip events newer than this datetime.
    Defaults to now.
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][Alias('CN','Server')][string[]]$ComputerName,
[Parameter(Position=1)][DateTime]$After = ([DateTime]::Today),
[Parameter(Position=2)][DateTime]$Before = ([DateTime]::Now),
[switch]$AllProperties
)
$IdFields = @{
    # 5, 9, 21 (1) Classic ASP errors, no fields
    # 1020 (0) IIS config failure, no fields
    # 1309 (30) late runtime issues
    1309 = @('EventCode','EventMessage','EventTime','EventTimeUtc','EventId','EventSequence','EventOccurrence',
        'EventDetailCode','AppDomain','TrustLevel','AppPath','AppLocalPath','MachineName','_','ProcessId','ProcessName',
        'AccountName','ExceptionType','ExceptionMessage','RequestUrl','RequestPath','UserHostAddress','User','IsAuthenticated',
        'AuthenticationType','ReqThreadAccountName','ThreadId','ThreadAccountName','IsImpersonating','StackTrace','CustomEventDetails')
    # 1310 (30) early configuration-type issues
    1310 = @('EventCode','EventMessage','EventTime','EventTimeUtc','EventId','EventSequence','EventOccurrence',
        'EventDetailCode','AppDomain','TrustLevel','AppPath','AppLocalPath','MachineName','_','ProcessId','ProcessName',
        'AccountName','ExceptionType','ExceptionMessage','RequestUrl','RequestPath','UserHostAddress','User','IsAuthenticated',
        'AuthenticationType','ReqThreadAccountName','ThreadId','ThreadAccountName','IsImpersonating','StackTrace','CustomEventDetails')
    # 1314 (24) access issues
    1314 = @('EventCode','EventMessage','EventTime','EventTimeUtc','EventId','EventSequence','EventOccurrence',
        'EventDetailCode','AppDomain','TrustLevel','AppPath','AppLocalPath','MachineName','_','ProcessId','ProcessName',
        'AccountName','RequestUrl','RequestPath','UserHostAddress','User','IsAuthenticated','AuthenticationType',
        'ThreadAccountName','CustomEventDetails')
    # 1315 (25) forms authentication failure
    1315 = @('EventCode','EventMessage','EventTime','EventTimeUtc','EventId','EventSequence','EventOccurrence',
        'EventDetailCode','AppDomain','TrustLevel','AppPath','AppLocalPath','MachineName','_','ProcessId','ProcessName',
        'AccountName','RequestUrl','RequestPath','UserHostAddress','User','IsAuthenticated','AuthenticationType',
        'ThreadAccountName','CustomEventDetails')
    # 1316 (31) session state failure
    1316 = @('EventCode','EventMessage','EventTime','EventTimeUtc','EventId','EventSequence','EventOccurrence',
        'EventDetailCode','AppDomain','TrustLevel','AppPath','AppLocalPath','MachineName','_','ProcessId','ProcessName',
        'AccountName','ExceptionType','ExceptionMessage','RequestUrl','RequestPath','UserHostAddress','User','IsAuthenticated',
        'AuthenticationType','ReqThreadAccountName','ThreadId','ThreadAccountName','IsImpersonating','StackTrace','CustomEventDetails')
    # 1325 (1) serious low-level stuff, no fields
}
$order = 
    if($AllProperties) { @('MachineName','EventTime','EventTimeUtc','LogTime','EntryType','AppPath','ExceptionType',
        'ExceptionMessage','AccountName','UserHostAddress','IsImpersonating','IsAuthenticated','AuthenticationType','User','TrustLevel',
        'CustomEventDetails','AppLocalPath','RequestUrl','RequestPath','AppDomain','Source','EventCode','EventDetailCode','EventMessage',
        'EventOccurrence','EventSequence','EventId','ProcessName','ProcessId','ThreadId','ThreadAccountName','ReqThreadAccountName',
        'StackTrace') }
    else {  @('MachineName','EventTime','EventTimeUtc','LogTime','EntryType','AppPath','ExceptionType','ExceptionMessage','AccountName',
        'UserHostAddress','IsImpersonating','IsAuthenticated','CustomEventDetails') }
$RemoveFields= '_','ThreadAccountName','ReqThreadAccountName' # blank or redundant fields
$BoolFields= 'IsAuthenticated','IsImpersonating'
$IntFields= 'EventOccurrence','EventSequence','EventCode','EventDetailCode','ProcessId','ThreadId'
$query = [xml]@"
<QueryList>
    <Query Id="0" Path="Application">
        <Select Path="Application">*[System[Provider[@Name='Active Server Pages' 
                                                     or @Name='ASP.NET 2.0.50727.0' 
                                                     or @Name='ASP.NET 4.0.30319.0']
                                            and TimeCreated[@SystemTime &gt;= '$(Get-Date $After.ToUniversalTime() -Format yyyy-MM-ddTHH:mm:ss.000Z)' 
                                                            and @SystemTime &lt;= '$(Get-Date $Before.ToUniversalTime() -Format yyyy-MM-ddTHH:mm:ss.999Z)']]]</Select>
        <Suppress Path="Application">*[System[EventID=1017 
                                              or EventID=1019 
                                              or EventID=1023 
                                              or EventID=1025 
                                              or EventID=1076 
                                              or EventID=1077]]</Suppress>
    </Query>
</QueryList>
"@
Write-Verbose $query.OuterXml
$ComputerName |
    % {Get-WinEvent $query -CN $_} |
    % {
        $fields = @{EntryType=$_.LevelDisplayName;Source=$_.ProviderName}
        if($_.Properties.Count -lt 2 -or !$IdFields.Contains($_.Id))
        { # not structured nicely
            Write-Verbose "Unstructured:`n$($_.Message)"
            if($_.Message -match '(?m)^Application ID: (?<AppId>.+)$'){$fields.AppId=$Matches.AppId.TrimEnd()}
            if($_.Message -match '(?m)^Process ID: (?<ProcessId>.+)$'){$fields.ProcessId=[int]$Matches.ProcessId.TrimEnd()}
            if($_.Message -match '(?m)^Exception: (\w+\.)*(?<ExceptionType>\w+)\s*$'){$fields.ExceptionType=$Matches.ExceptionType}
            if($_.Message -match '(?m)^Message: (?<ExceptionMessage>.+)$'){$fields.ExceptionMessage=$Matches.ExceptionMessage.TrimEnd()}
            if($_.Message -match '(?ms)^StackTrace: (?<StackTrace>.+)$'){$fields.StackTrace=$Matches.StackTrace.TrimEnd()}
        }
        else
        {
            $values = $_.Properties |% Value
            $names = $IdFields[$_.Id]
            if($values.Length -gt $names.Length) { Write-Warning ('Unexpected field values: {0} > {1}' -f $values.Length,$names.Length) }
            0..($values.Length-1) |% {[void]$fields.Add($names[$_],$values[$_].TrimEnd())}
            $RemoveFields |% {$fields.Remove($_)}
            $BoolFields |% {$fields[$_]=[bool]$fields[$_]}
            $IntFields |% {$fields[$_]=[int]$fields[$_]}
            $fields.RequestUrl= [uri]$fields.RequestUrl
            $fields.EventTime= [datetime]::Parse($fields.EventTime,$null,[Globalization.DateTimeStyles]::AssumeLocal)
            if($AllProperties -or $fields.EventTime -ne $_.TimeCreated) {$fields.LogTime = $_.TimeCreated}
            $fields.EventTimeUtc= [datetime]::Parse($fields.EventTimeUtc,$null,[Globalization.DateTimeStyles]::AssumeUniversal)
            if(!$AllProperties -and $fields.EventTime -eq $fields.EventTimeUtc) {$fields.Remove('EventTimeUtc')}
            if($fields.ExceptionMessage -and $fields.StackTrace)
            { $fields.ExceptionMessage= $fields.ExceptionMessage.Replace($fields.StackTrace,'').TrimEnd() } # don't need stack trace twice
        }
        if($fields.Count -eq 2) {return}
        $ordered = [ordered]@{}
        $order |? {$fields.ContainsKey($_)} |% {[void]$ordered.Add($_,$fields.$_)}
        $event = New-Object PSObject -Property $ordered
        $event.PSObject.TypeNames.Insert(0,'AspNetApplicationEventLogEntry')
        $event
    }
