---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Split-FileName.ps1

## SYNOPSIS
Returns the specified part of the filename.

## SYNTAX

### __AllParameterSets (Default)
```
Split-FileName.ps1 [-Path] <String> [<CommonParameters>]
```

### HasExtension
```
Split-FileName.ps1 [-Path] <String> [-HasExtension] [<CommonParameters>]
```

### Extension
```
Split-FileName.ps1 [-Path] <String> [-Extension] [<CommonParameters>]
```

## DESCRIPTION
Split-FileName returns only the specified part of a filename: 
either the filename without extension (default) or extension.
It can also tell whether the filename has an extension.

## EXAMPLES

### EXAMPLE 1
```
Split-FileName.ps1 readme.txt
```

readme

### EXAMPLE 2
```
Split-FileName.ps1 readme.txt -Extension
```

․txt
(the leading .
is included, but can't be entered as such in this example)

### EXAMPLE 3
```
Split-FileName.ps1 readme.txt -HasExtension
```

True

## PARAMETERS

### -Path
A file path to extract a part of; the base name without extension by default.

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

### -HasExtension
Indicates that the path should be checked for the presence of an extension,
returning a boolean value.

```yaml
Type: SwitchParameter
Parameter Sets: HasExtension
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Extension
Indicates the path's extension should be returned.

```yaml
Type: SwitchParameter
Parameter Sets: Extension
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

### System.String file path to parse.
## OUTPUTS

### System.String containing the base file name (or extension),
### or System.Boolean if the -HasAttribute switch is present.
## NOTES

## RELATED LINKS
