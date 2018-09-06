<#
.Synopsis
    Easily query IIS logs.

.Parameter ComputerName
    Attempts to use the LogFiles$ share of the computers listed as the log directory.

.Parameter LogDirectory
    The directory(ies) containing the log files to query.

.Parameter After
    The minimum datetime to query.

.Parameter Before
    The maximum datetime to query.

.Parameter IpAddr
    The client IP address(es) to restrict the query to.

.Parameter Username
    The username to restrict the search to.

.Parameter Status
    The HTTP (major) status to restrict the search to.

.Parameter UriPathLike
    A "like" pattern to match against the requested URI stem/path.

.Parameter QueryLike
    A "like" pattern to match against the query string.

.Parameter ReferrerLike
    A "like" pattern to match against the HTTP referrer.

.Outputs
    System.Management.Automation.PSObject[] with properties from the log file
    for each request found:

    * Time: DateTime of the request.
    * Server: Address of the server.
    * Filename: Which log file the request was found in.
    * Line: The line of the log file containing the request detail.
    * IpAddr: The client address.
    * Username: The username of an authenticated request.
    * UserAgent: The browser identification string send by the client.
    * Method: The HTTP verb used by the request.
    * UriPath: The location on the web server requested.
    * Query: The GET query parameters requested.
    * Referrer: The location that linked to this request, if provided.
    * Status: The HTTP success/error code of the response.

.Component
    LogParser

.Link
    ConvertFrom-Csv

.Link
    Use-Command.ps1

.Link
    https://www.microsoft.com/download/details.aspx?id=24659

.Example
    Get-IisLog.ps1 -LogDirectory \\Server\c$\inetpub\logs\LogFiles\W3SVC1 -After 2014-03-30 -UriPathLike '/WebApp/%' |select -First 1
 
    Time      : 2014-03-31 15:56:45
    Server    : 192.168.1.99:80
    Filename  : ex140331.log
    Line      : 121555
    IpAddr    : 192.168.1.199
    Username  : 
    UserAgent : Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/6.0; SLCC2; .NET CLR 
                2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E; 
                InfoPath.3)
    Method    : GET
    UriPath   : /WebApp/
    Query     : 
    Referrer  : 
    Status    : 401.2
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject[]])] Param(
[Parameter(ParameterSetName='Server')][Alias('Server','CN')][string[]] $ComputerName,
[Parameter(ParameterSetName='Directory')][Alias('Dir')][IO.DirectoryInfo[]] $LogDirectory = $PWD.ProviderPath,
[Parameter(Position=1)][datetime] $After = [datetime]::MinValue,
[Parameter(Position=2)][datetime] $Before = '8191-12-31', # max logparser timestamp date
[Alias("ClientIP")][string[]] $IpAddr,
[string[]] $Username,
[int[]] $Status,
[string] $UriPathLike,
[string] $QueryLike,
[Alias("RefererLike")][string] $ReferrerLike
)

Use-Command.ps1 logparser "${env:ProgramFiles(x86)}\Log Parser 2.2\LogParser.exe" -msi http://download.microsoft.com/download/f/f/1/ff1819f9-f702-48a5-bbc7-c9656bc74de8/LogParser.msi

# get the log files
$LogDirectory = 
    if ($ComputerName) { $ComputerName |% {"\\$_\LogFiles$"} }
    else { $LogDirectory |% FullName }
$from = ' from ' +
    ((ls $LogDirectory -Filter *.log |
        ? LastWriteTime -GE $After.AddDays(-1) |
        ? CreationTime -LE $Before.AddDays(1) |
        % FullName) -join ',')
if($from -eq ' from ') { $from += $($LogDirectory|% {"$_\*.log"}) -join ',' }

# build the where clause
$where = @()
$where += " where to_localtime(to_timestamp(date,time)) between to_timestamp('$(Get-Date $After -Format 'yyyy-MM-dd HH:mm:ss')','yyyy-MM-dd HH:mm:ss')"
$where += "to_timestamp('$(Get-Date $Before -Format 'yyyy-MM-dd HH:mm:ss')','yyyy-MM-dd HH:mm:ss')"
if($IpAddr) { $where += "c-ip in ('$(($IpAddr |% {$_ -replace "'","''"}) -join '')')" }
if($Username) { $where += "cs-username in ('$(($Username |% {$_ -replace "'","''"}) -join '')')" }
if($Status) { $where += "sc-status in ($($Status -join ';'))" }
if($UriPathLike) { $where += "cs-uri-stem like '$($UriPathLike -replace "'","''")'" }
if($QueryLike) { $where += "cs-uri-query like '$($QueryLike -replace "'","''")'" }
if($ReferrerLike) { $where += "cs(Referer) like '$($ReferrerLike -replace "'","''")'" }
$where = $where -join "`n   and "

# assemble the SQL
$sql = @"
select to_localtime(to_timestamp(date,time)) as Time,
       strcat(s-ip,strcat(':',to_string(s-port))) as Server,
       extract_filename(LogFilename) as Filename, 
       LogRow as Line, 
       coalesce(c-ip,'') as IpAddress, 
       cs-username as Username,
       coalesce(replace_chr(cs(User-Agent),'+',' '),'') as UserAgent, 
       cs-method as Method,
       coalesce(cs-uri-stem,'') as UriPath, 
       coalesce(cs-uri-query,'') as Query,
       coalesce(cs(Referer),'') as Referrer,
       strcat(strcat(to_string(sc-status),'.'),to_string(sc-substatus)) as Status
  into STDOUT
 $from
$where
"@
Write-Verbose $sql
logparser $sql -i:IISW3C -o:TSV -headers:off -stats:off |
    ConvertFrom-Csv -Delimiter "`t" -Header 'Time','Server','Filename','Line','IpAddress','Username','UserAgent','Method','UriPath','Query','Referrer','Status' |
    % {
        [datetime]$_.Time = $_.Time
        [long]$_.Line = $_.Line
        [Net.IpAddress]$_.IpAddress = $_.IpAddress
        [Microsoft.PowerShell.Commands.WebRequestMethod]$_.Method = $_.Method
        [uri]$_.Referrer = $_.Referrer
        [decimal]$_.Status = $_.Status
        $_
    }
