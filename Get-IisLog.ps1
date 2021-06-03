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

.Parameter Method
    The HTTP method (GET or POST, &c) to restrict the search to.

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

.Link
    https://docs.microsoft.com/windows/win32/debug/system-error-codes

.Link
    https://support.microsoft.com/help/943891/the-http-status-code-in-iis-7-0-iis-7-5-and-iis-8-0

.Link
    https://docs.microsoft.com/dotnet/api/system.net.http.httpresponsemessage.statuscode

.Link
    https://docs.microsoft.com/dotnet/api/system.componentmodel.win32exception

.Example
    Get-IisLog.ps1 -LogDirectory \\Server\c$\inetpub\logs\LogFiles\W3SVC1 -After 2014-03-30 -UriPathLike '/WebApp/%' |select -First 1

    Time          : 2014-03-31 15:56:45
    Server        : 192.168.1.99:80
    Filename      : ex140331.log
    Line          : 121555
    IpAddr        : 192.168.1.199
    Username      :
    UserAgent     : Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.1; WOW64; Trident/6.0; SLCC2; .NET CLR
                    2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; .NET4.0E;
                    InfoPath.3)
    Method        : GET
    UriPath       : /WebApp/
    Query         :
    Referrer      :
    StatusCode    : 401
    Status        : Unauthorized
    SubStatusCode : 2
    SubStatus     : Logon failed due to server configuration.
    WinStatusCode : 5
    WinStatus     : Access is denied
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
[Parameter(ParameterSetName='Server')][Alias('Server','CN')][string[]] $ComputerName,
[Parameter(ParameterSetName='Directory')][Alias('Dir')][IO.DirectoryInfo[]] $LogDirectory = $PWD.ProviderPath,
[Parameter(Position=1)][datetime] $After = [datetime]::MinValue,
[Parameter(Position=2)][datetime] $Before = '8191-12-31', # max logparser timestamp date
[Alias("ClientIP")][string[]] $IpAddr,
[string[]] $Username,
[int[]] $Status,
[Microsoft.PowerShell.Commands.WebRequestMethod[]] $Method,
[string] $UriPathLike,
[string] $QueryLike,
[Alias("RefererLike")][string] $ReferrerLike,
[ValidateSet('IIS','IISW3C','W3C')][string] $LogFormat = 'iisw3c'
)

Use-Command.ps1 logparser "${env:ProgramFiles(x86)}\Log Parser 2.2\LogParser.exe" `
    -msi http://download.microsoft.com/download/f/f/1/ff1819f9-f702-48a5-bbc7-c9656bc74de8/LogParser.msi

function Format-DateTimeLiteral([Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][datetime]$DateTime)
{
    return "to_timestamp('$(Get-Date $DateTime -Format 'yyyy-MM-dd HH:mm:ss')','yyyy-MM-dd HH:mm:ss')"
}

$logRowName = @{
    IIS    = 'LogRow'
    IISW3C = 'LogRow'
    W3C    = 'RowNumber'
}

$iisSubStatus = @{
    '400.1' = 'Invalid Destination Header.'
    '400.2' = 'Invalid Depth Header.'
    '400.3' = 'Invalid If Header.'
    '400.4' = 'Invalid Overwrite Header.'
    '400.5' = 'Invalid Translate Header.'
    '400.6' = 'Invalid Request Body.'
    '400.7' = 'Invalid Content Length.'
    '400.8' = 'Invalid Timeout.'
    '400.9' = 'Invalid Lock Token.'
    '401.1' = 'Logon failed.'
    '401.2' = 'Logon failed due to server configuration.'
    '401.3' = 'Unauthorized due to ACL on resource.'
    '401.4' = 'Authorization failed by filter.'
    '401.5' = 'Authorization failed by ISAPI/CGI application.'
    '401.501' = 'Access Denied: Too many requests from the same client IP; Dynamic IP Restriction Concurrent request rate limit reached.'
    '401.502' = 'Forbidden: Too many requests from the same client IP; Dynamic IP Restriction Maximum request rate limit reached.'
    '401.503' = 'Access Denied: the IP address is included in the Deny list of IP Restriction'
    '401.504' = 'Access Denied: the host name is included in the Deny list of IP Restriction'
    '403.1' = 'Execute access forbidden.'
    '403.2' = 'Read access forbidden.'
    '403.3' = 'Write access forbidden.'
    '403.4' = 'SSL required.'
    '403.5' = 'SSL 128 required.'
    '403.6' = 'IP address rejected.'
    '403.7' = 'Client certificate required.'
    '403.8' = 'Site access denied.'
    '403.9' = 'Forbidden: Too many clients are trying to connect to the web server.'
    '403.10' = 'Forbidden: web server is configured to deny Execute access.'
    '403.11' = 'Forbidden: Password has been changed.'
    '403.12' = 'Mapper denied access.'
    '403.13' = 'Client certificate revoked.'
    '403.14' = 'Directory listing denied.'
    '403.15' = 'Forbidden: Client access licenses have exceeded limits on the web server.'
    '403.16' = 'Client certificate is untrusted or invalid.'
    '403.17' = 'Client certificate has expired or is not yet valid.'
    '403.18' = 'Cannot execute requested URL in the current application pool.'
    '403.19' = 'Cannot execute CGI applications for the client in this application pool.'
    '403.20' = 'Forbidden: Passport logon failed.'
    '403.21' = 'Forbidden: Source access denied.'
    '403.22' = 'Forbidden: Infinite depth is denied.'
    '403.501' = 'Forbidden: Too many requests from the same client IP; Dynamic IP Restriction Concurrent request rate limit reached.'
    '403.502' = 'Forbidden: Too many requests from the same client IP; Dynamic IP Restriction Maximum request rate limit reached.'
    '403.503' = 'Forbidden: the IP address is included in the Deny list of IP Restriction'
    '403.504' = 'Forbidden: the host name is included in the Deny list of IP Restriction'
    '404.0' = 'Not found.'
    '404.1' = 'Site Not Found.'
    '404.2' = 'ISAPI or CGI restriction.'
    '404.3' = 'MIME type restriction.'
    '404.4' = 'No handler configured.'
    '404.5' = 'Denied by request filtering configuration.'
    '404.6' = 'Verb denied.'
    '404.7' = 'File extension denied.'
    '404.8' = 'Hidden namespace.'
    '404.9' = 'File attribute hidden.'
    '404.10' = 'Request header too long.'
    '404.11' = 'Request contains double escape sequence.'
    '404.12' = 'Request contains high-bit characters.'
    '404.13' = 'Content length too large.'
    '404.14' = 'Request URL too long.'
    '404.15' = 'Query string too long.'
    '404.16' = 'DAV request sent to the static file handler.'
    '404.17' = 'Dynamic content mapped to the static file handler via a wildcard MIME mapping.'
    '404.18' = 'Querystring sequence denied.'
    '404.19' = 'Denied by filtering rule.'
    '404.20' = 'Too Many URL Segments'
    '404.501' = 'Not Found: Too many requests from the same client IP; Dynamic IP Restriction Concurrent request rate limit reached.'
    '404.502' = 'Not Found: Too many requests from the same client IP; Dynamic IP Restriction Maximum request rate limit reached.'
    '404.503' = 'Not Found: the IP address is included in the Deny list of IP Restriction'
    '404.504' = 'Not Found: the host name is included in the Deny list of IP Restriction'
    '500.0' = 'Module or ISAPI error occurred.'
    '500.11' = 'Application is shutting down on the web server.'
    '500.12' = 'Application is busy restarting on the web server.'
    '500.13' = 'Web server is too busy.'
    '500.15' = 'Direct requests for Global.asax are not allowed.'
    '500.19' = 'Configuration data is invalid.'
    '500.21' = 'Module not recognized.'
    '500.22' = 'An ASP.NET httpModules configuration does not apply in Managed Pipeline mode.'
    '500.23' = 'An ASP.NET httpHandlers configuration does not apply in Managed Pipeline mode.'
    '500.24' = 'An ASP.NET impersonation configuration does not apply in Managed Pipeline mode.'
    '500.50' = 'A rewrite error occurred during RQ_BEGIN_REQUEST notification handling. A configuration or inbound rule execution error occurred.'
    '500.51' = 'A rewrite error occurred during GL_PRE_BEGIN_REQUEST notification handling. A global configuration or global rule execution error occurred.'
    '500.52' = 'A rewrite error occurred during RQ_SEND_RESPONSE notification handling. An outbound rule execution occurred.'
    '500.53' = 'A rewrite error occurred during RQ_RELEASE_REQUEST_STATE notification handling. An outbound rule execution error occurred. The rule is configured to be executed before the output user cache gets updated.'
    '500.100' = 'Internal ASP error.'
    '502.1' = 'CGI application timeout.'
    '502.2' = 'Bad gateway: Premature Exit.'
    '502.3' = 'Bad Gateway: Forwarder Connection Error (ARR).'
    '502.4' = 'Bad Gateway: No Server (ARR).'
    '503.0' = 'Application pool unavailable.'
    '503.2' = 'Concurrent request limit exceeded.'
    '503.3' = 'ASP.NET queue full'
    '503.4' = 'FastCGI queue full'
}

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
$where += " where to_localtime(to_timestamp(date,time)) between $(Format-DateTimeLiteral $After)"
$where += Format-DateTimeLiteral $Before
if($IpAddr) { $where += "c-ip in ('$(($IpAddr |% {$_ -replace "'","''"}) -join '')')" }
if($Username) { $where += "cs-username in ('$(($Username |% {$_ -replace "'","''"}) -join '')')" }
if($Status) { $where += "sc-status in ($($Status -join ';'))" }
if($Method -and $Method.Length) { $where += "cs-method in ('$(($Method |% {"$_".ToUpperInvariant()}) -join "';'")')" }
if($UriPathLike) { $where += "cs-uri-stem like '$($UriPathLike -replace "'","''")'" }
if($QueryLike) { $where += "cs-uri-query like '$($QueryLike -replace "'","''")'" }
if($ReferrerLike) { $where += "cs(Referer) like '$($ReferrerLike -replace "'","''")'" }
$where = $where -join "`n   and "

# assemble the SQL
$sql = @"
select to_localtime(to_timestamp(date,time)) as Time,
       strcat(s-ip,strcat(':',to_string(s-port))) as Server,
       extract_filename(LogFilename) as Filename,
       $($logRowName[$LogFormat]) as Line,
       coalesce(c-ip,'') as IpAddress,
       cs-username as Username,
       coalesce(replace_chr(cs(User-Agent),'+',' '),'') as UserAgent,
       cs-method as Method,
       coalesce(cs-uri-stem,'') as UriPath,
       coalesce(cs-uri-query,'') as Query,
       coalesce(cs(Referer),'') as Referrer,
       sc-status as StatusCode,
       '' as Status,
       sc-substatus as SubStatusCode,
       '' as SubStatus,
       sc-win32-status as WinStatusCode,
       '' as WinStatus
  into STDOUT
 $from
$where
"@
Write-Verbose $sql
logparser $sql -i:$LogFormat -o:TSV -headers:off -stats:off |
    ConvertFrom-Csv -Delimiter "`t" -Header 'Time','Server','Filename','Line','IpAddress',
        'Username','UserAgent','Method','UriPath','Query','Referrer',
        'StatusCode','Status','SubStatusCode','SubStatus','WinStatusCode','WinStatus' |
    % {
        [datetime]$_.Time = $_.Time
        [long]$_.Line = $_.Line
        [Net.IpAddress]$_.IpAddress = $_.IpAddress
        [Microsoft.PowerShell.Commands.WebRequestMethod]$_.Method = $_.Method
        [uri]$_.Referrer = $_.Referrer
        $code = $_.StatusCode
        $_.Status = try{[Net.HttpStatusCode]$code}catch{"$code"}
        $iisFullStatus = $_.StatusCode + '.' + $_.SubStatusCode
        if($iisSubStatus.ContainsKey($iisFullStatus)) {$_.SubStatus = $iisSubStatus[$iisFullStatus]}
        $_.WinStatus = [ComponentModel.Win32Exception][uint32]$_.WinStatusCode
        $_
    }
