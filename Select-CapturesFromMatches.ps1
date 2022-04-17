<#
.SYNOPSIS
Selects named capture group values as note properties from Select-String MatchInfo objects.

.PARAMETER MatchInfo
The MatchInfo output from Select-String to select named capture group values from.

.PARAMETER ValuesOnly
Return the capture group values without building objects.

.INPUTS
Microsoft.PowerShell.Commands.MatchInfo, output from Select-String that used a pattern
with named capture groups.

.OUTPUTS
System.Management.Automation.PSObject containing selected capture group values.

.EXAMPLE
Select-String '^(?<Name>.*?\b)\s*(?<Email>\S+@\S+)$' addrbook.txt |Select-CapturesFromMatches.ps1

Name            Email
----            -----
Arthur Dent     adent@example.org
Tricia McMillan trillian@example.com
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject])] Param(
[Parameter(Position=0,ValueFromRemainingArguments=$true,ValueFromPipeline=$true)]
[Alias('InputObject')][Microsoft.PowerShell.Commands.MatchInfo]$MatchInfo,
[switch] $ValuesOnly
)
Process
{
	$value = @{}
	if($ValuesOnly)
	{
		return $MatchInfo.Matches.Groups.Value |select -Skip 1
	}
	elseif($PSVersionTable.PSEdition -eq 'Desktop' -and $PSVersionTable.CLRVersion -lt [version]4.7)
	{ # old CLR is really tedious to get group names
		[regex]$regex = $MatchInfo.Pattern
		$regex.GetGroupNames() |
			where {$_ -Match '\D'} |
			foreach {$value.Add($_,$MatchInfo.Matches.Groups[$regex.GroupNumberFromName($_)].Value)}
	}
	else
	{
		$MatchInfo.Matches.Groups |
			where Name -Match '\D' |
			foreach {$value.Add($_.Name,$_.Value)}
	}
	return [pscustomobject]$value
}
