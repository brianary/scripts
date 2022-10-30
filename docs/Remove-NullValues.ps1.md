---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Remove-NullValues.ps1

## SYNOPSIS
Removes dictionary entries with null vaules.

## SYNTAX

```
Remove-NullValues.ps1 [-InputObject] <IDictionary> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
@{ a = 1; b = $null; c = 3 } |Remove-NullValues.ps1
```

Name                           Value
----                           -----
c                              3
a                              1

## PARAMETERS

### -InputObject
A dictionary to remove the nulls from.

```yaml
Type: IDictionary
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

### System.Collections.IDictionary to remove nulls from.
## OUTPUTS

### System.Collections.IDictionary with null-valued entries removed.
## NOTES

## RELATED LINKS
