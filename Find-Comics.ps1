<#
.Synopsis
	Finds comics.

.Parameter Title
	Text to search titles. Comics with titles containing this text will be returned.

.Parameter Creator
	Text to search creators. Comics with creators containing this text will be returned.

.Parameter TitleMatch
	A regular exression to match titles. Comics with matching titles will be returned.

.Parameter CreatorMatch
	A regular expression to search the list of creators for.
	Comics with a matching list of creators will be returned.
	The regex will match against a complete list of creators, so anchor with word breaks (\b)
	rather than the beginning or end of the string (^ or $ or \A or \z).

	e.g. (W) Jason Aaron (A/CA) Russell Dauterman

	W = writer
	A = artist
	CA = color artist

.Parameter Condition
	A filtering script block with the comic as the PSItem ($_) that evaluates to true to
	return the comic.

.Parameter ReleaseWeek
	Specifies which week (relative to the current week) to return comics for.

.Link
	https://api.shortboxed.com/

.Link
	Get-Comics.ps1

.Example
	Find-Comics.ps1 -Creator 'Grant Morrison','Matt Fraction','David Aja','Kyle Higgins' |Format-Table publisher,title,creators

	publisher         title                                creators
	---------         -----                                --------
	BOOM! STUDIOS     KLAUS HC LIFE & TIMES OF SANTA CLAUS (W) Grant Morrison (A/CA) Dan Mora
	DARK HORSE COMICS SEEDS TP                             (W) Ann Nocenti (A/CA) David Aja
	MARVEL COMICS     MARVEL-VERSE GN-TP WANDA & VISION    (W) Kyle Higgins, More (A) Stephane Perger, More (CA) Daniel Acuna, Jim Cheung
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='Title',Mandatory=$true)][string[]] $Title,
[Parameter(ParameterSetName='Creator',Mandatory=$true)][string[]] $Creator,
[Parameter(ParameterSetName='TitleMatch',Mandatory=$true)][regex] $TitleMatch,
[Parameter(ParameterSetName='CreatorMatch',Mandatory=$true)][regex] $CreatorMatch,
[Parameter(ParameterSetName='Condition',Position=0,Mandatory=$true)][scriptblock] $Condition,
[Parameter()][ValidateSet('Upcoming','Current','Previous')][string] $ReleaseWeek = 'Upcoming'
)
switch($PSCmdlet.ParameterSetName)
{
	Title {Get-Comics.ps1 $ReleaseWeek -pv c |where {$Title |where {$c.title -like "*$_*"}}}
	Creator {Get-Comics.ps1 $ReleaseWeek -pv c |where {$Creator |where {$c.creators -like "*$_*"}}}
	TitleMatch {Get-Comics.ps1 $ReleaseWeek |where {$_.title -match $TitleMatch}}
	CreatorMatch {Get-Comics.ps1 $ReleaseWeek |where {$_.creators -match $CreatorMatch}}
	Condition {Get-Comics.ps1 $ReleaseWeek |where $Condition}
}
