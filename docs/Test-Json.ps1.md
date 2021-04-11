---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-Json.ps1

## SYNOPSIS
Determines whether a string is valid JSON.

## SYNTAX

```
Test-Json.ps1 [-InputObject] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-Json.ps1 '{"value":6}'
```

True

### EXAMPLE 2
```
Test-Json.ps1 0
```

True

### EXAMPLE 3
```
Test-Json.ps1 '{'
```

False

## PARAMETERS

### -InputObject
The string to test.

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

### System.String value to test for a valid JSON format.
## OUTPUTS

### System.Boolean indicating that the string can be parsed as JSON.
## NOTES

## RELATED LINKS
