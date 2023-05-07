<#
.SYNOPSIS
Finds comics.

.FUNCTIONALITY
Comics

.LINK
https://api.shortboxed.com/

.LINK
Get-Comics.ps1

.EXAMPLE
Find-Comics.ps1 -Creator 'Grant Morrison','Matt Fraction','David Aja','Kyle Higgins' |Format-Table publisher,title,creators

publisher         title                                creators
---------         -----                                --------
BOOM! STUDIOS     KLAUS HC LIFE & TIMES OF SANTA CLAUS (W) Grant Morrison (A/CA) Dan Mora
DARK HORSE COMICS SEEDS TP                             (W) Ann Nocenti (A/CA) David Aja
MARVEL COMICS     MARVEL-VERSE GN-TP WANDA & VISION    (W) Kyle Higgins, More (A) Stephane Perger, More (CA) Daniel Acuna, Jim Cheung
#>

#Requires -Version 3
[CmdletBinding()] Param(
# Text to search titles. Comics with titles containing this text will be returned.
[Parameter(ParameterSetName='Title',Mandatory=$true)][string[]] $Title,
# Text to search creators. Comics with creators containing this text will be returned.
[Parameter(ParameterSetName='Creator',Mandatory=$true)][string[]] $Creator,
# A regular exression to match titles. Comics with matching titles will be returned.
[Parameter(ParameterSetName='TitleMatch',Mandatory=$true)][regex] $TitleMatch,
<#
A regular expression to search the list of creators for.
Comics with a matching list of creators will be returned.
The regex will match against a complete list of creators, so anchor with word breaks (\b)
rather than the beginning or end of the string (^ or $ or \A or \z).

e.g. (W) Jason Aaron (A/CA) Russell Dauterman

W = writer
A = artist
CA = color artist
#>
[Parameter(ParameterSetName='CreatorMatch',Mandatory=$true)][regex] $CreatorMatch,
<#
A filtering script block with the comic as the PSItem ($_) that evaluates to true to
return the comic.
#>
[Parameter(ParameterSetName='Condition',Position=0,Mandatory=$true)][scriptblock] $Condition,
# Specifies which week (relative to the current week) to return comics for.
[Parameter()][ValidateSet('Upcoming','Current','Previous')][string] $ReleaseWeek = 'Upcoming'
)
switch($PSCmdlet.ParameterSetName)
{
	Title {Get-Comics.ps1 $ReleaseWeek -pv c |Where-Object {$Title |Where-Object {$c -and $c.title -like "*$_*"}}}
	Creator {Get-Comics.ps1 $ReleaseWeek -pv c |Where-Object {$Creator |Where-Object {$c -and $c.creators -like "*$_*"}}}
	TitleMatch {Get-Comics.ps1 $ReleaseWeek |Where-Object {$_.title -match $TitleMatch}}
	CreatorMatch {Get-Comics.ps1 $ReleaseWeek |Where-Object {$_.creators -match $CreatorMatch}}
	Condition {Get-Comics.ps1 $ReleaseWeek |Where-Object $Condition}
}
