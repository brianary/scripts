<#
.Synopsis
	Creates and starts an HTTP listener, for testing HTTP clients.

.Parameter Port
    Ports on the localhost to bind to.

.Parameter AuthenticationSchemes
    Client authentication methods to support.

.Parameter Realm
    The RFC2617 security

.Parameter IgnoreWriteExceptions
    Indicates that response writes shouldn't generate exceptions.

.Outputs
    System.Web.HttpListener to receive requests.

.Link
    https://docs.microsoft.com/dotnet/api/system.net.httplistener

.Link
    https://tools.ietf.org/html/rfc2617#section-1.2

.Example
    $Listener = Start-HttpListener.ps1 8080

    Creates and starts an HTTP listener at http://localhost:8080/
#>

#Requires -Version 3
[CmdletBinding(DefaultParameterSetName='Port')][OutputType([Net.HttpListener])] Param(
[Parameter(ParameterSetName='Port',Position=0,Mandatory=$true,ValueFromRemainingArguments=$true)]
[ValidateCount(1,2147483647)][int[]] $Port,
[Net.AuthenticationSchemes[]] $AuthenticationSchemes = 'Anonymous',
[string] $Realm,
[switch] $IgnoreWriteExceptions
)
try{[void][Net.HttpListener]}
catch{Add-Type -AN Net.HttpListener |Out-Null}
try{[void][Web.HttpContext]}
catch{Add-Type -AN System.Web |Out-Null}
if(![Net.HttpListener]::IsSupported)
{Stop-ThrowError.ps1 InvalidOperationException "This $($env:os) doesn't support .NET HTTP listeners." InvalidOperation $env:os OS}
[Net.HttpListener]$Listener = New-Object Net.HttpListener -Property @{AuthenticationSchemes=$AuthenticationSchemes}
if($Port) {$BindUrl = $Port |foreach {[uri]"http://localhost:$_/"}}
$BindUrl |where {!$Listener.Prefixes.Contains($_)} |foreach {$Listener.Prefixes.Add($_)}
$Listener.Start()
$Listener |Out-String |Write-Verbose
$Listener
