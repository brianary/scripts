<#
.SYNOPSIS
Imports iCal events and converts them into a Mermaid Gantt chart for each day, sectioned by location.

.FUNCTIONALITY
Mermaid Diagrams

.INPUTS
Any object with these properties:
* Id: [string] A unique identifier for the event.
* Title: [string] Required. The name of the event.
* Location: [string] Where the event is held
* Url: [uri] A link to more information about the event.
* Start: When the event begins, as a DateTime, string, or Ical.Net.DataTypes.CalDateTime.
* End: When the event concludes, as a DateTime, string, or Ical.Net.DataTypes.CalDateTime.

.OUTPUTS
System.String containing a Mermaid Gantt chart for the day.

.LINK
https://datatracker.ietf.org/doc/html/rfc5545

.LINK
https://mermaid.js.org/syntax/gantt.html

.LINK
New-Guid

.LINK
Get-Date

.EXAMPLE
ImportIcal\Import-Calendar -String (Invoke-RestMethod https://spokanefilmfestival.org/events/?ical=1) |Select-Object -ExpandProperty Events |Convert-ICalToMermaidGantt.ps1

---
displayMode: compact
---
gantt
title Saturday March 7, 2026
dateFormat HH:mm
axisFormat %H:%M
tickInterval 1hour
todayMarker off
...
#>

#Requires -Version 7
[CmdletBinding(DefaultParameterSetName='Event')] Param(
[Parameter(ValueFromPipelineByPropertyName=$true)][Alias('Uid')][string] $Id = (New-Guid).ToString('D'),
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('Summary')][string] $Title,
[Parameter(ValueFromPipelineByPropertyName=$true)][string] $Location,
[Parameter(ValueFromPipelineByPropertyName=$true)][uri] $Url,
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)] $Start,
[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)] $End
)
Begin
{
    $Script:EventList = @()
    $Script:DayChart = @()

    filter Format-Event
    {
        [CmdletBinding()] Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)][string] $Id,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][string] $Title,
        [Parameter(ValueFromPipelineByPropertyName=$true)][string] $Location,
        [Parameter(ValueFromPipelineByPropertyName=$true)][uri] $Url,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][datetime] $Start,
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)][datetime] $End
        )
        if($Url)
        {
            return @"
$Title : $Id, $(Get-Date $Start -Format HH:mm), $(Get-Date $End -Format HH:mm)
click $Id href "$Url"
"@
        }
        else
        {
            return @"
$Title : $(Get-Date $Start -Format HH:mm), $(Get-Date $End -Format HH:mm)
"@
        }
    }

    filter Format-Location
    {
        [CmdletBinding()] Param(
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $Name,
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][psobject[]] $Group
        )
        $Local:OFS = [System.Environment]::NewLine
        return @"
section $Name
$($Group |Format-Event)
"@
    }

    filter Format-Day
    {
        [CmdletBinding()] Param(
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][string] $Name,
        [Parameter(ValueFromPipelineByPropertyName=$true,Mandatory=$true)][psobject[]] $Group
        )
        $Local:OFS = [System.Environment]::NewLine
        return @"
---
displayMode: compact
---
gantt
title $(Get-Date $Name -Format 'dddd MMMM d, yyyy')
dateFormat HH:mm
axisFormat %H:%M
tickInterval 1hour
todayMarker off
$($Group |Group-Object Location |Format-Location)
"@
    }
}
Process
{
    if(Get-Member -InputObject $Start -Name AsDateTimeOffset -Type Property) {$Start = $Start.AsDateTimeOffset.LocalDateTime}
    elseif($Start -is [string]) {$Start = Get-Date $Start}
    elseif($Start -isnot [datetime]) {Stop-ThrowError.ps1 'Start was not a DateTime' -Argument Start}
    if(Get-Member -InputObject $End -Name AsDateTimeOffset -Type Property) {$End = $End.AsDateTimeOffset.LocalDateTime}
    elseif($End -is [string]) {$End = Get-Date $End}
    elseif($End -isnot [datetime]) {Stop-ThrowError.ps1 'End was not a DateTime' -Argument 'End'}
    $Script:EventList += [pscustomobject]@{
        Id       = "id-$Id"
        Title    = $Title
        Location = $Location
        Url      = $Url
        Start    = $Start
        End      = $End
    }
}
End
{
    $Script:EventList |
        Sort-Object Start, End, Location |
        Group-Object {Get-Date $_.Start -Format yyyy-MM-dd} |
        ForEach-Object {$Script:DayChart += $_ |Format-Day}
    return $Script:DayChart
}
