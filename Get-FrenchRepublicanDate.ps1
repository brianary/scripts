<#
.Synopsis
	Returns a date and time converted to the French Republican Calendar.

.Parameter Date
	The Gregorian calendar date and time to convert.

.Parameter Method
	Which method to use to calculate leap years, of the competing choices.

.Link
	https://wikipedia.org/wiki/French_Republican_calendar

.Link
	https://wikipedia.org/wiki/Equinox

.Link
	https://www.timeanddate.com/calendar/seasons.html

.Link
	https://www.projectpluto.com/calendar.htm

.Link
	https://github.com/Bill-Gray/lunar/blob/master/date.cpp#L340

.Link
	http://rosettacode.org/wiki/French_Republican_calendar

.Link
	http://www.windhorst.org/calendar/

.Link
	Stop-ThrowError.ps1
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,ValueFromPipeline)][datetime] $Date = (Get-Date),
[ValidateSet('Equinox','Romme','Continuous','128Year')][string] $Method = 'Romme'
)
Begin
{
	function Measure-LeapDays
	{
		[CmdletBinding()] Param(
		[Parameter(Position=0,Mandatory=$true)][int] $ToYear,
		[Parameter(Position=1,Mandatory=$true)][ScriptBlock] $Condition,
		[Parameter(Position=2)][int] $FromYear = 1
		)
		($FromYear..($ToYear-1) |where $Condition |measure).Count
	}
	${les mois} = 'Vendémiaire','Brumaire','Frimaire','Nivôse','Pluviôse','Ventôse',
		'Germinal','Floréal','Prairial','Messidor','Thermidor','Fructidor','Sansculottides'
	$months = 'Grape Harvest','Fog','Frost','Snowy','Rainy','Windy',
		'Germination','Flowering','Meadow','Harvest','Heat','Fruit','Complementary Days'
	${les jours du decade} = 'Primidi','Duodi','Tridi','Quartidi','Quintidi','Sextidi','Septidi','Octidi','Nonidi','Décadi'
	${les jours} = 1..366 #TODO: day names
}
Process
{ # 1792-09-22 = 1 Vendémiaire Ⅰ
	if($Date -lt [datetime]'1792-09-22')
	{
		Stop-ThrowError.ps1 NotImplementedException 'Dates prior to September 22, 1792 are not yet supported.' `
			NotImplemented $Date NEGATIVE
	}
	[int] $lastleapt = if([datetime]::IsLeapYear($Date.Year) -and $Date.DayOfYear -gt 59) {$Date.Year} else {$Date.Year -1}
	[int] $gregleaps = Measure-LeapDays $lastleapt {[datetime]::IsLeapYear($_)} 1796
	[datetime] $d = $Date.AddDays(-265).AddYears(-1791)
	[ScriptBlock] $test =
		switch($Method)
		{ #TODO: implement equinox
			128Year {{!($_ % 4) -and ($_ % 128)}}
			Continuous {{[datetime]::IsLeapYear($_+1)}}
			Equinox {Stop-ThrowError.ps1 NotImplementedException 'Equinox isn supported yet' NotImplemented $Date EQUINOX}
			Romme {{[datetime]::IsLeapYear($_)}}
		}
	[int] $lastyearlength = if($test.InvokeWithContext($null,[psvariable[]]@(New-Object psvariable '_',($d.Year-1)),$null)) {366} else {365}
	[int] $frcleaps = Measure-LeapDays ($d.Year-1) $test
	[int] ${l'année} = $d.Year
	[int] ${jour de l'année} = $d.DayOfYear + $frcleaps - $gregleaps #TODO: fix
	if(${jour de l'année} -lt 1) {${l'année}--; ${jour de l'année} = $lastyearlength + ${jour de l'année}}
	[int] $mois = [math]::Floor(${jour de l'année}/30)
	[pscustomobject]@{
		Year = ${l'année}
		Month = $mois +1
		MonthName = $months[$mois]
		Mois = ${les mois}[$mois]
		Day = ${jour de l'année} % 30
		DayName = ${les jours}[${jour de l'année}]
		Decade = 1 + [math]::Floor((${jour de l'année} -1) / 10)
		DayOfDecade = 1 + ((${jour de l'année} -1) % 10)
		DayNameOfDecade = ${les jours du decade}[(${jour de l'année} -1) % 10]
	}
}
