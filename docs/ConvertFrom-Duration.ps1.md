---
external help file: -help.xml
Module Name:
online version: https://en.wikipedia.org/wiki/ISO_8601#Durations
schema: 2.0.0
---

# ConvertFrom-Duration.ps1

## SYNOPSIS
Parses a Timespan from a ISO8601 duration string.

## SYNTAX

```
ConvertFrom-Duration.ps1 [[-InputObject] <String[]>] [-NoWarnings] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
"$(ConvertFrom-Duration.ps1 P1D)"
```

1.00:00:00

### EXAMPLE 2
```
"$(ConvertFrom-Duration.ps1 P3Y6M4DT12H30M5S)"
```

WARNING: Adding year(s) as a mean number of days (365.2425).
WARNING: Adding month(s) as a mean number of days (30.436875).
1283.12:30:05

## PARAMETERS

### -InputObject
An ISO8601 duration string in one of four formats:

    * PnYnMnDTnHnMnS
    * PnW
    * Pyyyy-MM-ddTHH:mm:ss
    * PyyyyMMddTHHmmss

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -NoWarnings
Supresses warnings about approximate conversions.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Quiet

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String containing an ISO8601 duration.
## OUTPUTS

### System.Timespan containing the duration, as parsed and converted to a Timespan.
## NOTES

## RELATED LINKS

[https://en.wikipedia.org/wiki/ISO_8601#Durations](https://en.wikipedia.org/wiki/ISO_8601#Durations)

[Import-Variables.ps1]()

[Test-Variable.ps1]()

[Stop-ThrowError.ps1]()

