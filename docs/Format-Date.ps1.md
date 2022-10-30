---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Format-Date.ps1

## SYNOPSIS
Returns a date/time as a named format.

## SYNTAX

```
Format-Date.ps1 [-Format] <String> [[-Date] <DateTime>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Format-Date Iso8601WeekDate 2021-01-20
```

2021-W03-3

### EXAMPLE 2
```
'Feb 2, 2020 8:20 PM +00:00' |Format-Date Iso8601Z
```

2020-02-02T20:20:00Z

## PARAMETERS

### -Format
The format to serialize the date as.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Date
The date/time value to format.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Get-Date)
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS

[Get-Date]()

