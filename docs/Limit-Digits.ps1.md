---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Limit-Digits.ps1

## SYNOPSIS
Rounds off a number to the requested number of digits.

## SYNTAX

```
Limit-Digits.ps1 [[-Digits] <Int32>] [-InputObject] <Object> [-Mode <MidpointRounding>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
[math]::PI |Limit-Digits.ps1 4
```

3.1416

### EXAMPLE 2
```
1.5 |Limit-Digits.ps1 -Mode ToZero
```

1

## PARAMETERS

### -Digits
The number of digits following the decimal to truncate the value to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
A numeric value to round off.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Mode
The rounding methodology to use.

```yaml
Type: MidpointRounding
Parameter Sets: (All)
Aliases:
Accepted values: ToEven, AwayFromZero, ToZero, ToNegativeInfinity, ToPositiveInfinity

Required: False
Position: Named
Default value: ToEven
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Decimal or System.Double or other numeric type that is implicitly convertible
### to those types.
## OUTPUTS

### System.Decimal or System.Double depending on input type.
## NOTES

## RELATED LINKS
