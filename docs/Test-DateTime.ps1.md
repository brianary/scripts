---
external help file: -help.xml
Module Name:
online version: https://msdn.microsoft.com/library/8kb3ddd4.aspx
schema: 2.0.0
---

# Test-DateTime.ps1

## SYNOPSIS
Tests whether the given string can be parsed as a date.

## SYNTAX

```
Test-DateTime.ps1 [-Date] <String> [-Format <String[]>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-DateTime.ps1 '2017-02-29T11:38:00'
```

False

### EXAMPLE 2
```
Test-DateTime.ps1 '2000-2-29T9:33:00' -Format 'yyyy-M-dTH:mm:ss'
```

True

### EXAMPLE 3
```
Test-Datetime.ps1 970313 -Format 'yyMMdd'
```

True

### EXAMPLE 4
```
Test-DateTime.ps1 '1900-02-29'
```

False

## PARAMETERS

### -Date
The string to test for datetime parseability.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Format
Precise, known format(s) to use to try parsing the datetime.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String containing a possible date to test parse.
## OUTPUTS

### System.Boolean indicating the string is a parseable date.
## NOTES

## RELATED LINKS

[https://msdn.microsoft.com/library/8kb3ddd4.aspx](https://msdn.microsoft.com/library/8kb3ddd4.aspx)

