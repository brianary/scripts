<#
.Synopsis
    Displays upcoming comics based on search criteria.

.Parameter Condition
    A ScriptBlock that defines a search.
    See links for available fields.

.Link
    https://api.shortboxed.com/

.Link
    Test-Variable.ps1

.Example
    Show-UpcomingComics.ps1 {$_.creators -like '*Grant Morrison*'}

    (Any matched comics.)

.Example
	Show-UpcomingComics.ps1 {$_.title -like '*The Shadow*'}

	(Any matched comics.)
#>

[CmdletBinding()][OutputType([psobject])] Param(
[Parameter(Position=0,Mandatory=$true)][scriptblock]$Condition
)
if(!(Test-Variable.ps1 UpcomingComics -Scope Global) -or (Get-Date) -gt [datetime]$UpcomingComics.comics[0].release_date)
{$Global:UpcomingComics = irm https://api.shortboxed.com/comics/v1/future}
if(!($UpcomingComics.comics |where $Condition)) {Write-Verbose "No comics found: $Condition"}
else
{
    Write-Host "Upcoming Comics $(Get-Date $UpcomingComics.comics[0].release_date -f 'ddd MMM d'): $Condition"
    $UpcomingComics.comics |where $Condition |Format-Table publisher,title,creators |Out-String |Write-Host
}
