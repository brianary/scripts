<#
.Synopsis
    Scan sites using Mozilla's Observatory.

.Parameter Hosts
    Hostnames to scan, e.g. www.example.org

.Parameter Rescan
    Indicates a new scan should be performed, rather than returning a cached one.

.Parameter Public
    Indicates the scan results may be posted publically.

.Parameter Endpoint
    The address of the Observatory web service.

.Link
    Invoke-RestMethod

.Link
    https://observatory.mozilla.org/

.Example
    Test-HttpSecurity.ps1 www.example.net -Public -Rescan
#>

#Requires -Version 3
[CmdletBinding()]Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][string[]]$Hosts,
[switch]$Rescan,
[switch]$Public,
[Uri]$Endpoint = 'https://http-observatory.security.mozilla.org/api/v1'
)
Process
{
    $scan = @{}
    $Hosts |% {$scan.Add($_,(Invoke-RestMethod "$Endpoint/analyze?host=$_" -Body @{hidden=!$Public;rescan=$Rescan} -Method Post))}

    while($pending = $scan.Keys |? {$scan.$_.state -like '*ING'})
    {
        sleep -Milliseconds 1600
        $pending |% {$scan.$_ = Invoke-RestMethod "$Endpoint/analyze" -Body @{host=$_} -Method Get}
    }

    $scan.Keys |% {
        Add-Member results "$Endpoint/getScanResults?scan=$($scan.$_.scan_id)" -InputObject $scan.$_
        Add-Member host $_ -InputObject $scan.$_ -PassThru
    }
}