---
external help file: -help.xml
Module Name:
online version: https://www.microsoft.com/en-us/download/details.aspx?id=24659
schema: 2.0.0
---

# ConvertTo-LogParserTimestamp.ps1

## SYNOPSIS
Formats a datetime as a LogParser literal.

## SYNTAX

```
ConvertTo-LogParserTimestamp.ps1 [-Value] <DateTime> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
logparser "select * from ex17*.log where to_localtime(timestamp(date,time)) < $(Get-Date|ConvertTo-LogParserTimestamp.ps1)"
```

## PARAMETERS

### -Value
The DateTime value to convert to a LogParser literal.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.DateTime to encode for use as a literal in a LogParser query.
## OUTPUTS

### System.String to use as a timestamp literal in a LogParser query.
## NOTES

## RELATED LINKS

[https://www.microsoft.com/en-us/download/details.aspx?id=24659](https://www.microsoft.com/en-us/download/details.aspx?id=24659)

