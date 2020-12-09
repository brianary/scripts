<#
.Synopsis
	Displays a formatted date using powerline font characters.

.Parameter Format
	The format to serialize the date as.

.Parameter Date
	The date/time value to format.

.Parameter Separator
	The separator to use between formatted dates.

.Parameter ForegroundColor
	The foreground console color to use.

.Parameter BackgroundColor
	The background console color to use.

.Link
	Get-Unicode.ps1

.Link
	Format-Date.ps1

.Link
	Get-Date

.Example
	Show-Time.ps1 Iso8601Z Iso8601WeekDate Iso8601OrdinalDate -Separator ' * '

	( 2020-12-08T03:59:39Z * 2020-W50-1 * 2020-342 )
	(but using powerline graphics)
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromRemainingArguments=$true)]
[ValidateSet('FrenchRepublicanDateTime','Iso8601','Iso8601Date','Iso8601OrdinalDate',
'Iso8601Week','Iso8601WeekDate','Iso8601Z','LocalLongDate','LocalLongDateTime','Rfc1123','Rfc1123Gmt')]
[string[]] $Format,
[Parameter(ValueFromPipeline=$true)][datetime] $Date = (Get-Date),
[string] $Separator = " $(Get-Unicode.ps1 0x2022) ",
[consolecolor] $ForegroundColor = $host.UI.RawUI.BackgroundColor,
[consolecolor] $BackgroundColor = $host.UI.RawUI.ForegroundColor
)

Write-Host (Get-Unicode.ps1 0xE0B6) -ForegroundColor $BackgroundColor -NoNewline
Write-Host ' ' -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline
Write-Host (($Format |foreach {Format-Date.ps1 $_ -Date $Date}) -join $Separator) `
	-ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline
Write-Host ' ' -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline
Write-Host (Get-Unicode.ps1 0xE0B4) -fore $BackgroundColor
