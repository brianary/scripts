<#
.Synopsis
    Looks up DNS info, given a hostname or address.

.Parameter HostName
    A host name or address to look up.

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
[Alias('Address','HostAddress','Name')][string[]]$HostName
)

Process { $HostName |% {[net.dns]::GetHostEntry($_)} }
