<#
.Synopsis
    Adds named capture groups as note properties to Select-String's MatchInfo objects.

.Parameter MatchInfo
    The MatchInfo output from Select-String to augment with named capture groups.

.Inputs
    Microsoft.PowerShell.Commands.MatchInfo, output from Select-String that used a pattern
    with named capture groups.

.Outputs
    Microsoft.PowerShell.Commands.MatchInfo with additional note properties for each named
    capture group.

.Link
    Add-Member

.Example
    Select-String '^(?<Name>.*?\b)\s*(?<Email>\S+@\S+)$' addrbook.txt |Add-CapturesToMatches.ps1 |select Name,Phone,Filename

    Name            Email                Filename
    ----            -----                --------
    Arthur Dent     adent@example.org    addrbook.txt
    Tricia McMillan trillian@example.com addrbook.txt
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Microsoft.PowerShell.Commands.MatchInfo])] Param(
[Parameter(Position=0,ValueFromRemainingArguments=$true,ValueFromPipeline=$true)]
[Alias('InputObject')][Microsoft.PowerShell.Commands.MatchInfo]$MatchInfo
)
Process
{
    $MatchInfo.Matches.Groups |
        ? Name -Match '\D' |
        % {Add-Member -InputObject $MatchInfo -MemberType NoteProperty -Name $_.Name -Value $_.Value}
    $MatchInfo
}
