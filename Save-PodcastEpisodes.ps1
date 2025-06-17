﻿<#
.SYNOPSIS
Downloads enclosures from a podcast feed.

.LINK
Save-WebRequest.ps1

.EXAMPLE
Save-PodcastEpisodes.ps1 https://www.youlooknicetoday.com/rss -UseTitle

Downloads podcast episodes to the current directory.
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The URL of the podcast feed.
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Alias('Url')][uri] $Uri,
# Episodes before this date will be ignored.
[datetime] $After,
# Episodes after this date will be ignored.
[datetime] $Before,
# Includes only the given number of initial episodes, by publish date.
[int] $First,
# Includes only the given number of most recent episodes, by publish date.
[int] $Last,
# Use episode titles for filenames.
[switch] $UseTitle,
# Downloads the episodes into a folder with the podcast name.
[switch] $CreateFolder
)
Process
{
	$channel = ([xml]((Invoke-WebRequest $Uri).Content)).rss.channel
	$channel |Format-List |Out-String |Write-Verbose
	$activity = "Downloading $($channel.title)"
	[object[]] $episodes = Invoke-RestMethod $Uri
	foreach($episode in $episodes) {$episode |Add-Member published ([datetime]$episode.pubDate)}
	if($PSBoundParameters.ContainsKey('After')) {[object[]] $episodes = $episodes |Where-Object published -gt $After}
	if($PSBoundParameters.ContainsKey('Before')) {[object[]] $episodes = $episodes |Where-Object published -lt $Before}
	if($PSBoundParameters.ContainsKey('First')) {[object[]] $episodes = $episodes |Sort-Object published |Select-Object -First $First}
	if($PSBoundParameters.ContainsKey('Last')) {[object[]] $episodes = $episodes |Sort-Object published |Select-Object -Last $Last}
	if($CreateFolder) {New-Item ($channel.title |ConvertTo-FileName.ps1) -ItemType Directory -EA Ignore |Push-Location}
	$i,$max = 0,($episodes.Count/100)
	foreach($episode in $episodes)
	{
		$episode |Format-List |Out-String |Write-Verbose
		$title = $episode.title |Select-Object -First 1
		Write-Progress $activity $title -curr $episode.pubDate -percent ($i++/$max)
		if(!$episode.PSObject.Properties.Match('enclosure').Count)
		{
			Write-Warning "No enclosure found for '$title', $($episode.pubDate)"
			continue
		}
		if($UseTitle)
		{
			$filename = if($episode.PSObject.Properties.Match('episode')) {$episode.episode + ' '} else {''}
			$filename += $title |ConvertTo-FileName.ps1
			$filename += Split-Uri.ps1 $episode.enclosure.url -Extension
			Invoke-WebRequest $episode.enclosure.url -OutFile $filename
			(Get-Item $filename).CreationTime = $episode.published
		}
		else
		{
			Save-WebRequest.ps1 $episode.enclosure.url -CreationTime $episode.published
		}
	}
	if($CreateFolder) {Pop-Location}
	Write-Progress $activity -Completed
}
