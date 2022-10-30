---
external help file: -help.xml
Module Name:
online version: https://en.wikipedia.org/wiki/Unix_time
schema: 2.0.0
---

# ConvertTo-EpochTime.ps1

## SYNOPSIS
Converts a DateTime value into an integer Unix (POSIX) time, seconds since Jan 1, 1970.

## SYNTAX

```
ConvertTo-EpochTime.ps1 [-DateTime] <DateTime> [-UniversalTime] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-Date |ConvertTo-EpochTime.ps1
```

1556884381

## PARAMETERS

### -DateTime
The DateTime value to convert to number of seconds since Jan 1, 1970.

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

### -UniversalTime
Indicates the DateTime provided is local, and should be converted to UTC.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: UTC

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.DateTime values to convert to integers.
## OUTPUTS

### System.Int32 values converted from date and time values.
## NOTES

## RELATED LINKS

[https://en.wikipedia.org/wiki/Unix_time](https://en.wikipedia.org/wiki/Unix_time)

[https://stackoverflow.com/a/1860511/54323](https://stackoverflow.com/a/1860511/54323)

[Get-Date]()

