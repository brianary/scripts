<#
.Synopsis
    Looks up DNS info, given a hostname or address.

.Parameter HostName
    A host name or address to look up.

.Parameter OnlyAddresses
    Indicates that only the string versions of addresses belonging to the specified family should be returned.
    "Unknown" returns all addresses.

.Link
    https://msdn.microsoft.com/library/ms143998.aspx

.Example
    Get-Dns.ps1 www.google.com

    HostName       Aliases AddressList
    --------       ------- -----------
    www.google.com {}      {172.217.10.132}
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromRemainingArguments=$true,ValueFromPipeline=$true)]
[Alias('Address','HostAddress','Name')][string[]] $HostName,
[Net.Sockets.AddressFamily] $OnlyAddresses
)

Process
{
    foreach ($h in $HostName)
    {
        $entry = [Net.Dns]::GetHostEntry($h)
        if(!$PSBoundParameters.ContainsKey('OnlyAddresses')) {$entry}
        elseif($OnlyAddresses -eq [Net.Sockets.AddressFamily]::Unspecified) {$entry.AddressList |foreach {$_.IPAddressToString}}
        else {$entry.AddressList |where AddressFamily -eq $OnlyAddresses |foreach {$_.IPAddressToString}}
    }
}
