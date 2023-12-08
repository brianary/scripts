---
external help file: -help.xml
Module Name:
online version: https://en.wikipedia.org/wiki/Unix_time
schema: 2.0.0
---

# ConvertFrom-EpochTime.ps1

## SYNOPSIS
Converts an integer Unix (POSIX) time (seconds since Jan 1, 1970) into a DateTime value.

## SYNTAX

```
ConvertFrom-EpochTime.ps1 [-InputObject] <Int64> [-UniversalTime] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
1556884381 |ConvertFrom-EpochTime.ps1
```

Friday, May 3, 2019 11:53:01

## PARAMETERS

### -InputObject
The Epoch time value to convert to a DateTime.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -UniversalTime
Indicates the DateTime provided is local, and should be converted to UTC.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: UTC, Z

Required: False
Position: Named
Default value: False
Accept pipeline input: False
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

### System.Int32 value converted from date and time value.
## OUTPUTS

### System.DateTime value to convert to integer.
## NOTES

## RELATED LINKS

[https://en.wikipedia.org/wiki/Unix_time](https://en.wikipedia.org/wiki/Unix_time)

[https://stackoverflow.com/a/1860511/54323](https://stackoverflow.com/a/1860511/54323)

[Get-Date]()

