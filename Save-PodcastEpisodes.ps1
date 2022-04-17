<#
.SYNOPSIS
Saves enclosures from a podcast feed.

.PARAMETER Uri
The URL of the podcast feed.

.PARAMETER After
Episodes before this date will be ignored.

.PARAMETER Before
Episodes after this date will be ignored.

.PARAMETER First
Includes only the given number of initial episodes, by publish date.

.PARAMETER Last
Includes only the given number of most recent episodes, by publish date.

.PARAMETER UseTitle
Use episode titles for filenames.

.PARAMETER CreateFolder
Saves the episodes into a folder with the podcast name.

.LINK
Save-WebRequest.ps1

.EXAMPLE
Save-PodcastEpisodes.ps1 https://www.youlooknicetoday.com/rss -UseTitle

Saves podcast episodes to the current directory.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][Alias('Url')][uri] $Uri,
[datetime] $After,
[datetime] $Before,
[int] $First,
[int] $Last,
[switch] $UseTitle,
[switch] $CreateFolder
)
Begin
{
	[regex] $invalidchars = "(?:$(([io.path]::GetInvalidFileNameChars() |foreach {'\x{0:X2}' -f [int]$_}) -join '|'))+"
}
Process
{
	$channel = ([xml]((Invoke-WebRequest $Uri).Content)).rss.channel
	$channel |Format-List |Out-String |Write-Verbose
	$activity = "Downloading $($channel.title)"
	[object[]] $episodes = Invoke-RestMethod $Uri
	foreach($episode in $episodes) {$episode |Add-Member published ([datetime]$episode.pubDate)}
	if($PSBoundParameters.ContainsKey('After')) {[object[]] $episodes = $episodes |where published -gt $After}
	if($PSBoundParameters.ContainsKey('Before')) {[object[]] $episodes = $episodes |where published -lt $Before}
	if($PSBoundParameters.ContainsKey('First')) {[object[]] $episodes = $episodes |sort published |select -First $First}
	if($PSBoundParameters.ContainsKey('Last')) {[object[]] $episodes = $episodes |sort published |select -Last $Last}
	if($CreateFolder) {New-Item ($channel.title -replace $invalidchars,'_') -ItemType Directory |Push-Location}
	$i,$max = 0,($episodes.Count/100)
	foreach($episode in $episodes)
	{
		$episode |Format-List |Out-String |Write-Verbose
		$title = $episode.title |select -First 1
		Write-Progress $activity $title -curr $episode.enclosure.url -percent ($i++/$max)
		if($UseTitle)
		{
			$filename = if($episode.PSObject.Properties.Match('episode')) {$episode.episode + ' '} else {''}
			$filename += $title -replace $invalidchars,'_'
			$filename += [io.path]::GetExtension($episode.enclosure.url)
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
