---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Measure-StandardDeviation.ps1

## SYNOPSIS
Calculate the standard deviation of numeric values.

## SYNTAX

```
Measure-StandardDeviation.ps1 [[-InputObject] <Double[]>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-Process |% Handles |Measure-StandardDeviation.ps1
```

1206.54722086141

## PARAMETERS

### -InputObject
The numeric values to analyze.

```yaml
Type: Double[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
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

### A collection of System.Double values
## OUTPUTS

### System.Double
## NOTES

## RELATED LINKS

[Measure-Object]()

