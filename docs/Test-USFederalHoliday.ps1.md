---
external help file: -help.xml
Module Name:
online version: http://www.federalreserve.gov/aboutthefed/k8.htm
schema: 2.0.0
---

# Test-USFederalHoliday.ps1

## SYNOPSIS
Returns true if the given date is a U.S.
federal holiday.

## SYNTAX

```
Test-USFederalHoliday.ps1 [-Date] <DateTime> [-AsHolidayName] [-SatToFri] [-SunToMon] [<CommonParameters>]
```

## DESCRIPTION
The following holidays are checked:

       * New Year's Day, January 1 (± 1 day, if observed)
       * Birthday of Martin Luther King, Jr., Third Monday in January
       * Washington's Birthday, Third Monday in February
       * Memorial Day, Last Monday in May
       * Juneteenth, June 19 (± 1 day, if observed)
       * Independence Day, July 4 (± 1 day, if observed)
       * Labor Day, First Monday in September
       * Columbus Day, Second Monday in October
       * Veterans Day, November 11 (±1 day, if observed)
       * Thanksgiving Day, Fourth Thursday in November
       * Christmas Day, December 25 (±1 day, if observed)

## EXAMPLES

### EXAMPLE 1
```
Test-USFederalHoliday.ps1 2016-11-11
```

Veterans Day

### EXAMPLE 2
```
Test-USFederalHoliday.ps1 2017-02-20
```

Washington's Birthday

### EXAMPLE 3
```
if(Test-USFederalHoliday.ps1 (Get-Date)) { return }
```

Returns from a function or script if today is a holiday.

## PARAMETERS

### -Date
The date to check.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AsHolidayName
Return the holiday name?

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ReturnName, ReturnHolidayName

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SatToFri
Indicates Saturday holidays are observed on Fridays.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SunToMon
Indicates Sunday holidays are observed on Mondays.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.DateTime values to check.
## OUTPUTS

### System.Boolean indicating whether the date is a holiday.
## NOTES
Thanks to the Uniform Monday Holiday Act, Washington's "Birthday" always falls
*between* Washington's birthdays.
He had two, and we still decided to celebrate
a third day.

https://en.wikipedia.org/wiki/Uniform_Monday_Holiday_Act

https://en.wikipedia.org/wiki/Washington%27s_Birthday#History

## RELATED LINKS

[http://www.federalreserve.gov/aboutthefed/k8.htm](http://www.federalreserve.gov/aboutthefed/k8.htm)

