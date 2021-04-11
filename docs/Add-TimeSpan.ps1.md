---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Add-TimeSpan.ps1

## SYNOPSIS
Adds a timespan to DateTime values.

## SYNTAX

```
Add-TimeSpan.ps1 [-TimeSpan] <TimeSpan> [-DateTime] <DateTime> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-Date |Add-TimeSpan.ps1 00:00:30
```

Adds 30 seconds to the current date and time value.

## PARAMETERS

### -TimeSpan
The TimeSpan value to add.

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DateTime
The DateTime value to add to.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.DateTime values to add the TimeSpan value to.
## OUTPUTS

### System.DateTime values with the TimeSpan added.
## NOTES

## RELATED LINKS
