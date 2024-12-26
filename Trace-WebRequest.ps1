<#
.SYNOPSIS
Provides details about a retrieving a URI.

.NOTES
TODO: Add support for other Invoke-WebRequest parameters.

.INPUTS
System.Uri to retrieve.

.FUNCTIONALITY
HTTP

.LINK
Import-CharConstants.ps1

.LINK
Write-Info.ps1

.LINK
Import-Variables.ps1

.EXAMPLE
Trace-WebRequest.ps1 g.co/p3phelp -SkipContent

📤️ GET g.co/p3phelp

📥️ HTTP/1.1 301 MovedPermanently
Cache-Control: no-store, must-revalidate, no-cache, max-age=0
Pragma: no-cache
Date: Thu, 26 Dec 2024 21:08:21 GMT
Location: https://g.co/p3phelp
Server: ESF
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Content-Type: application/binary
Expires: Mon, 01 Jan 1990 00:00:00 GMT
Content-Length: 0
ℹ️ Following redirect to https://g.co/p3phelp
📤️ GET https://g.co/p3phelp

📥️ HTTP/1.1 302 Found
Vary: Sec-Fetch-Dest
Vary: Sec-Fetch-Mode
Vary: Sec-Fetch-Site
Cache-Control: no-store, must-revalidate, no-cache, max-age=0
Pragma: no-cache
Date: Thu, 26 Dec 2024 21:08:22 GMT
Location: https://support.google.com/accounts/answer/151657?hl=en
Strict-Transport-Security: max-age=31536000
Cross-Origin-Opener-Policy: unsafe-none
Cross-Origin-Resource-Policy: same-site
Server: ESF
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Alt-Svc: h3=":443"; ma=2592000
Alt-Svc: h3-29=":443"; ma=2592000
Content-Type: application/binary
Expires: Mon, 01 Jan 1990 00:00:00 GMT
Content-Length: 0
ℹ️ Following redirect to https://support.google.com/accounts/answer/151657?hl=en
📤️ GET https://support.google.com/accounts/answer/151657?hl=en

📥️ HTTP/1.1 301 MovedPermanently
Location: https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638708441023370154-2201542783&rd=1
X-Robots-Tag: follow,index
Date: Thu, 26 Dec 2024 21:08:22 GMT
Cache-Control: max-age=0, private
X-Content-Type-Options: nosniff
Server: support-content-ui
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
Alt-Svc: h3=":443"; ma=2592000
Alt-Svc: h3-29=":443"; ma=2592000
Expires: Thu, 26 Dec 2024 21:08:22 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 304
ℹ️ Following redirect to https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638708441023370154-2201542783&rd=1
📤️ GET https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638708441023370154-2201542783&rd=1

📥️ HTTP/1.1 301 MovedPermanently
Location: https://support.google.com/accounts/?hl=en&visit_id=638708441023370154-2201542783&rd=2&topic=3382252
X-Robots-Tag: follow,noindex
Date: Thu, 26 Dec 2024 21:08:22 GMT
Cache-Control: max-age=0, private
X-Content-Type-Options: nosniff
Server: support-content-ui
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
Alt-Svc: h3=":443"; ma=2592000
Alt-Svc: h3-29=":443"; ma=2592000
Expires: Thu, 26 Dec 2024 21:08:22 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 309
ℹ️ Following redirect to https://support.google.com/accounts/?hl=en&visit_id=638708441023370154-2201542783&rd=2&topic=3382252
📤️ GET https://support.google.com/accounts/?hl=en&visit_id=638708441023370154-2201542783&rd=2&topic=3382252

📥️ HTTP/1.1 200 OK
P3P: CP="This is not a P3P policy! See g.co/p3phelp for more info."
P3P: CP="This is not a P3P policy! See g.co/p3phelp for more info."
P3P: CP="This is not a P3P policy! See g.co/p3phelp for more info."
Strict-Transport-Security: max-age=31536000; includeSubdomains
Date: Thu, 26 Dec 2024 21:08:23 GMT
Cache-Control: max-age=0, private
Content-Security-Policy-Report-Only: object-src 'none';base-uri 'self';script-src 'nonce-69sNhX1vigTzFtuMUufk' 'unsafe-inline' 'unsafe-eval' 'strict-dynamic' https: http: 'report-sample';report-uri https://csp.withgoogle.com/csp/scfe
X-Content-Type-Options: nosniff
Server: support-content-ui
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
Alt-Svc: h3=":443"; ma=2592000
Alt-Svc: h3-29=":443"; ma=2592000
Transfer-Encoding: chunked
Content-Type: text/html; charset=UTF-8
Expires: Thu, 26 Dec 2024 21:08:23 GMT
#>

using namespace System.Net.Http
#Requires -Version 7
[CmdletBinding()] Param(
# The URL to retrieve.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('Url','Href','Src')][uri] $Uri,
# The HTTP method verb to use.
[HttpMethod] $Method = 'GET',
# A file to log the request to.
[string] $LogFile,
# Indicates content shouldn't be output.
[switch] $SkipContent
)
Begin
{
    Import-CharConstants.ps1 :outbox_tray: :inbox_tray: :information_source: -AsEmoji

    filter Get-HttpStatusColor
    {
        [CmdletBinding()][OutputType([ConsoleColor])] Param(
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][int] $Code
        )
        switch([int]::DivRem($Code, 100).Item1)
        {
            1 {return [ConsoleColor]::White}
            2 {return [ConsoleColor]::Green}
            3 {return [ConsoleColor]::Blue}
            4 {return [ConsoleColor]::Red}
            5 {return [ConsoleColor]::DarkRed}
        }
    }

    function Trace-Uri
    {
        [CmdletBinding()] Param(
        # The URL to retrieve.
        [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias('Url','Href','Src')][uri] $Uri,
        # The HTTP method verb to use.
        [HttpMethod] $Method = 'GET'
        )
        $request = New-Object Net.Http.HttpRequestMessage -ArgumentList $Method, $Uri
        $requestLine, $requestRawHeaders = "$Method $Uri", ($request.Headers.ToString())
        Write-Verbose $requestLine
        Write-Verbose $requestRawHeaders
        Write-Info.ps1 "$outbox_tray $requestLine" -fg DarkGreen
        Write-Info.ps1 $requestRawHeaders -fg DarkGray
        if($LogFile)
        {@"
###
$Method $Uri
$requestRawHeaders
"@ |Add-Content $LogFile
        }
        Write-Debug $requestLine
        $StatusCode = 0
        Invoke-WebRequest -Uri $Uri -SkipHttpErrorCheck -MaximumRedirection 0 -AllowInsecureRedirect -EA Ignore |
            Import-Variables.ps1
        if(!$StatusCode)
        {
            if($LogFile)
            {@"
###
# Response: $($_.Message)
"@ |Add-Content $LogFile
            }
            return
        }
        $statusLine, $rawHeaders = ($RawContent -replace '(?s)\r?\n\r?\n.*\z') -split '\r?\n',2
        if($null -eq $rawHeaders) {$rawHeaders = ''}
        Write-Verbose $statusLine
        Write-Verbose $rawHeaders
        Write-Info.ps1 "$inbox_tray $statusLine" -fg (Get-HttpStatusColor $StatusCode)
        Write-Info.ps1 $rawHeaders -fg Gray
        if(!$SkipContent -and $Content) {Write-Info.ps1 $Content -fg White}
        if($LogFile)
        {@"
###
# Response:
$RawContent
"@ |Add-Content $LogFile
        }
        if([int]::DivRem($StatusCode, 100).Item1 -eq 3)
        {
            foreach($location in $Headers.Location)
            {
                Write-Info.ps1 "$information_source Following redirect to $location" -fg DarkBlue
                Trace-Uri $location
            }
        }
    }
}
Process
{
    Trace-Uri -Uri $Uri -Method $Method
}
