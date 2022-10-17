<#
.SYNOPSIS
Adds named capture group values as note properties to Select-String MatchInfo objects.

.DESCRIPTION
Navigating the .NET Regex Group and Capture collections to find a capture group can be
a hassle in some versions of PowerShell.

To simplifies this process, this script just adds simple properties to the MatchInfo objects.

.INPUTS
Microsoft.PowerShell.Commands.MatchInfo, output from Select-String that used a pattern
with named capture groups.

.OUTPUTS
Microsoft.PowerShell.Commands.MatchInfo with additional note properties for each named
capture group.

.LINK
Add-Member

.EXAMPLE
Select-String '^(?<Name>.*?\b)\s*(?<Email>\S+@\S+)$' addrbook.txt |Add-CapturesToMatches.ps1 |select Name,Email,Filename

Name            Email                Filename
----            -----                --------
Arthur Dent     adent@example.org    addrbook.txt
Tricia McMillan trillian@example.com addrbook.txt
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Microsoft.PowerShell.Commands.MatchInfo])] Param(
# The MatchInfo output from Select-String to augment with named capture group values.
[Parameter(Position=0,ValueFromRemainingArguments=$true,ValueFromPipeline=$true)]
[Alias('InputObject')][Microsoft.PowerShell.Commands.MatchInfo]$MatchInfo
)
Process
{
	if($PSVersionTable.PSEdition -eq 'Desktop' -and $PSVersionTable.CLRVersion -lt [version]4.7)
	{ # old CLR is really tedious to get group names
		[regex]$regex = $MatchInfo.Pattern
		$regex.GetGroupNames() |
			Where-Object {$_ -Match '\D'} |
			ForEach-Object {Add-Member -InputObject $MatchInfo $_ $MatchInfo.Matches.Groups[$regex.GroupNumberFromName($_)].Value}
	}
	else
	{
		$MatchInfo.Matches.Groups |
			Where-Object Name -Match '\D' |
			ForEach-Object {Add-Member -InputObject $MatchInfo $_.Name $_.Value}
	}
	$MatchInfo
}
