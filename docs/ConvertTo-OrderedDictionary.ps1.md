---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# ConvertTo-OrderedDictionary.ps1

## SYNOPSIS
Converts an object to an ordered dictionary of properties and values.

## SYNTAX

```
ConvertTo-OrderedDictionary.ps1 [-InputObject] <Object> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
ls *.txt |ConvertTo-OrderedDictionary.ps1
```

## PARAMETERS

### -InputObject
An object to convert to a dictionary.

```yaml
Type: Object
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

### Any .NET object to convert into a properties hash.
## OUTPUTS

### System.Collections.Specialized.OrderedDictionary of the object's property names and values.
## NOTES

## RELATED LINKS

[Get-Member]()

