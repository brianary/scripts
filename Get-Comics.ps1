<#
.SYNOPSIS
Returns a cached list of comics from the Shortboxed API.

.PARAMETER ReleaseWeek
Specifies which week (relative to the current week) to return comics for.

.LINK
https://api.shortboxed.com/

.LINK
Invoke-WebRequest

.LINK
ConvertFrom-Json

.LINK
Get-Date
#>

#Requires -Version 3
[CmdletBinding()][OutputType([psobject[]])] Param(
[Parameter(Position=0)][ValidateSet('Upcoming','Current','Previous')][string] $ReleaseWeek = 'Upcoming'
)
$cachedir = '~/.shortboxed'
if(!(Test-Path $cachedir -Type Container)) {mkdir $cachedir}
$name = switch($ReleaseWeek)
{
	Upcoming {'future'}
	Current {'new'}
	Previous {'previous'}
}
$file = "$cachedir/$name.json"
if( !(Test-Path $file -Type Leaf) -or
	(Get-Date (Get-Date).AddDays(-1) -uf %Y-%W) -ne (Get-Date (Get-Item $file).LastWriteTime.AddDays(-1) -uf %Y-%W) )
{ Invoke-WebRequest https://api.shortboxed.com/comics/v1/$name -OutFile $file }
(Get-Content $file |ConvertFrom-Json).comics
