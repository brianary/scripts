---
external help file: -help.xml
Module Name:
online version: https://wikipedia.org/wiki/French_Republican_calendar
schema: 2.0.0
---

# Get-FrenchRepublicanDate.ps1

## SYNOPSIS
Returns a date and time converted to the French Republican Calendar.

## SYNTAX

```
Get-FrenchRepublicanDate.ps1 [[-Date] <DateTime>] [-Method <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-FrenchRepublicanDate.ps1 2020-07-08
```

Year          : 228
Annee         : CCXXVIII
AnneeUnicode  : ⅭⅭⅩⅩⅧ
Month         : 10
MonthName     : Harvest
Mois          : Messidor
Day           : 21
DayOfYear     : 291
Jour          : Menthe
DayName       : Mint
Decade        : 30
DayOfDecade   : 1
DecadeOrdinal : Primidi
DecimalTime   : 0:00:00
GregorianDate : 2020-07-08 00:00:00

## PARAMETERS

### -Date
The Gregorian calendar date and time to convert.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Get-Date)
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Method
Which method to use to calculate leap years, of the competing choices.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 128Year
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.DateTime containing the Gregorian date and time to convert.
## OUTPUTS

### System.Management.Automation.PSCustomObject containing a French Republican Calendar
### date and time in these properties:
### * Year: the numeric year
### * Annee: the Roman numeral year
### * AnneeUnicode: the Unicode Roman numeral year
### * Month: the numeric month
### * MonthName: the English month name
### * Mois: the French month name
### * Day: the numeric day of the month
### * DayOfYear: the numeric day of the year
### * Jour: the French name of the day of the year
### * DayName: the English name of the day of the year
### * Decade: the number of the 10-day "week" of the year
### * DayOfDecade: the numeric day of the 10-day "week"
### * DecadeOrdinal: the name of the day of the 10-day "week"
### * DecimalTime: the decimal time (10 hours/day, 100 minutes/hour, 100 seconds/minute)
### * GregorianDate: the original Gregorian date, as provided
## NOTES

## RELATED LINKS

[https://wikipedia.org/wiki/French_Republican_calendar](https://wikipedia.org/wiki/French_Republican_calendar)

[https://wikipedia.org/wiki/Equinox](https://wikipedia.org/wiki/Equinox)

[https://www.timeanddate.com/calendar/seasons.html](https://www.timeanddate.com/calendar/seasons.html)

[https://www.projectpluto.com/calendar.htm](https://www.projectpluto.com/calendar.htm)

[https://github.com/Bill-Gray/lunar/blob/master/date.cpp#L340](https://github.com/Bill-Gray/lunar/blob/master/date.cpp#L340)

[http://rosettacode.org/wiki/French_Republican_calendar](http://rosettacode.org/wiki/French_Republican_calendar)

[http://www.windhorst.org/calendar/](http://www.windhorst.org/calendar/)

[Stop-ThrowError.ps1]()

