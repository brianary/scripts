---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Merge-Json.ps1

## SYNOPSIS
Create a new JSON string by recursively combining the properties of JSON strings.

## SYNTAX

```
Merge-Json.ps1 [-InputObject] <String[]> [-Compress] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
'{"a":1,"b":{"u":3},"c":{"v":5}}','{"a":{"w":8},"b":2,"c":{"x":6}}' |Merge-Json.ps1
```

{
    "a":  {
            "w":  8
        },
    "b":  2,
    "c":  {
            "v":  5,
            "x":  6
        }
}

## PARAMETERS

### -InputObject
JSON string to combine.
Descendant properties are recursively merged.
Primitive values are overwritten by any matching ones in the new JSON string.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Compress
Omits white space and indented formatting in the output string.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String of JSON to combine.
## OUTPUTS

### System.String of JSON combining the inputs.
## NOTES

## RELATED LINKS

[Merge-PSObject.ps1]()

[ConvertFrom-Json]()

[ConvertTo-Json]()

