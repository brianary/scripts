---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Measure-Values.ps1

## SYNOPSIS
Provides analysis of supplied values.

## SYNTAX

```
Measure-Values.ps1 [[-InputObject] <Object>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
1..54 |ForEach-Object {Get-Random} |Measure-Values.ps1
```

Type              : System.Int32
Values            : 54
NullValues        : 0
IsUnique          : True
UniqueValues      : 54
Minimum           : 94194382
Maximum           : 2128816298
MeanAverage       : 1088097395.2963
MedianAverage     : 1223934436
ModeAverage       : 1088097395.2963
Variance          : 3.74619103093056E+17
StandardDeviation : 612061355.660571

### EXAMPLE 2
```
1..127 |ForEach-Object {Get-Date -UnixTimeSeconds (Get-Random)} |Measure-Values.ps1
```

Type                     : System.DateTime
Values                   : 127
NullValues               : 0
IsUnique                 : True
UniqueValues             : 127
IsDateOnly               : False
DateOnlyValues           : 0
DateTimeValues           : 127
Minimum                  : 1970-12-23 12:18:33
Maximum                  : 2037-10-28 21:09:37
MostCommonValue          : 1970-12-23 12:18:33
MeanAverage              : 2002-09-23 09:03:30
MedianAverage            : 2002-07-23 06:51:20
ModeAverage              : 2002-09-23 09:03:30
UniqueYears              : 59
MeanAverageYear          : 2002
MedianAverageYear        : 2002
ModeAverageYear          : 1979
StandardDeviationYear    : 20.9125879067699
UniqueMonths             : 12
MinimumMonth             : January
MaximumMonth             : December
MeanAverageMonth         : July
MedianAverageMonth       : June
ModeAverageMonth         : May
StandardDeviationMonth   : 3.45228333389263
January                  : 10
Febuary                  : 6
March                    : 16
April                    : 7
May                      : 19
June                     : 11
July                     : 6
August                   : 7
September                : 14
October                  : 10
November                 : 7
December                 : 14
UniqueDays               : 29
MinimumDay               : 1
MaximumDay               : 30
MeanAverageDay           : 15.4645669291339
MedianAverageDay         : 15
ModeAverageDay           : 7
StandardDeviationDay     : 8.53172908617298
UniqueWeekdays           : 7
MinimumWeekday           : Sunday
MaximumWeekday           : Saturday
MeanAverageWeekday       : Wednesday
MedianAverageWeekday     : Wednesday
ModeAverageWeekday       : Wednesday
StandardDeviationWeekday : 1.92091482392633
Sunday                   : 13
Monday                   : 20
Tuesday                  : 21
Wednesday                : 23
Thursday                 : 16
Friday                   : 15
Saturday                 : 19

## PARAMETERS

### -InputObject
The values to analyze.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object values to be analyzed in aggregate.
## OUTPUTS

### System.Management.Automation.PSCustomObject that describes the values with properties like
### MeanAverage and StandardDeviation.
## NOTES

## RELATED LINKS
