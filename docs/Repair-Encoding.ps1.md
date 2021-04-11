---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Repair-Encoding.ps1

## SYNOPSIS
Re-encodes Windows-1252 text that has been misinterpreted as UTF-8.

## SYNTAX

```
Repair-Encoding.ps1 [-InputObject] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Repair-Encoding.ps1 'SmartQuotes Arenâ€™t'
```

SmartQuotes Aren't

## PARAMETERS

### -InputObject
The string containing encoding failures to fix.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String containing encoding failures to fix.
## OUTPUTS

### System.String containing the corrected string data.
## NOTES

## RELATED LINKS
