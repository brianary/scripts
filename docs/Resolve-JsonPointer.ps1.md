---
external help file: -help.xml
Module Name:
online version: https://www.rfc-editor.org/rfc/rfc6901
schema: 2.0.0
---

# Resolve-JsonPointer.ps1

## SYNOPSIS
Returns a value from a JSON string or file.

## SYNTAX

### InputObject
```
Resolve-JsonPointer.ps1 [[-JsonPointer] <String>] [-InputObject <Object>] [-IncludePath]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Path
```
Resolve-JsonPointer.ps1 [[-JsonPointer] <String>] -Path <String> [-IncludePath]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
'{a:1}' |Resolve-JsonPointer.ps1 /*
```

/a

### EXAMPLE 2
```
Resolve-JsonPointer.ps1 /powershell.*.preset -Path ./.vscode/settings.json
```

/powershell.codeFormatting.preset

### EXAMPLE 3
```
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Resolve-JsonPointer.ps1 /*/ZZ?ZZ/AD?BC
```

/b/ZZ~1ZZ/AD~0BC

### EXAMPLE 4
```
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Resolve-JsonPointer.ps1 /[bc]/ZZ?ZZ
```

/b/ZZ~1ZZ

### EXAMPLE 5
```
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |ConvertFrom-Json |Resolve-JsonPointer.ps1 /?/ZZ*/*BC
```

/b/ZZ~1ZZ/AD~0BC

## PARAMETERS

### -JsonPointer
The full path name of the property to get, as a JSON Pointer, modified to support wildcards:
~0 = ~  ~1 = /  ~2 = ? 
~3 = *  ~4 = \[

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
The JSON (string or parsed object/hashtable) to get the value from.

```yaml
Type: Object
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
A JSON file to update.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludePath
Indicates that the source file path should be included in the output, if available.

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

### System.String containing JSON, or
### System.Collections.Hashtable parsed from JSON, or
### System.Management.Automation.PSObject parsed from JSON.
## OUTPUTS

### System.String of the full JSON Pointer matched.
## NOTES

## RELATED LINKS

[https://www.rfc-editor.org/rfc/rfc6901](https://www.rfc-editor.org/rfc/rfc6901)

[ConvertFrom-Json]()

