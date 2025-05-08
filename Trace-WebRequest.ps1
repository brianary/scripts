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
Trace-WebRequest.ps1 g.co/p3phelp -SkipHeaders -SkipContent

GET https://g.co/p3phelp
HTTP/1.1 302 Found                                                                                                   
Following redirect to https://support.google.com/accounts/answer/151657?hl=en
GET https://support.google.com/accounts/answer/151657?hl=en
HTTP/1.1 301 MovedPermanently                                                                                        
Following redirect to https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638822697229889622-2656653887&rd=1
GET https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638822697229889622-2656653887&rd=1
HTTP/1.1 301 MovedPermanently                                                                                        
Following redirect to https://support.google.com/accounts/?hl=en&visit_id=638822697229889622-2656653887&rd=2&topic=3382252
GET https://support.google.com/accounts/?hl=en&visit_id=638822697229889622-2656653887&rd=2&topic=3382252
HTTP/1.1 200 OK
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
# Indicates headers shouldn't be output.
[switch] $SkipHeaders,
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
        #Write-Info.ps1 $requestRawHeaders -fg DarkGray
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
        if(!$SkipHeaders) {Write-Info.ps1 $rawHeaders -fg Gray}
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
            foreach($location in $Headers.Location |ForEach-Object {New-Object Uri $Uri,$_})
            {
                Write-Info.ps1 "$information_source Following redirect to $location" -fg DarkBlue
                Trace-Uri $location
            }
        }
    }
}
Process
{
    if(!$Uri.IsAbsoluteUri -and [uri]::IsWellFormedUriString("https://$Uri", 'Absolute'))
    {
        [uri] $Uri = "https://$Uri"
    }
    Trace-Uri -Uri $Uri -Method $Method
}
