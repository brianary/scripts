---
external help file: -help.xml
Module Name:
online version: https://datatracker.ietf.org/doc/html/draft-ietf-appsawg-json-pointer-04
schema: 2.0.0
---

# Select-Json.ps1

## SYNOPSIS
Returns a value from a JSON string or file.

## SYNTAX

### InputObject
```
Select-Json.ps1 [[-PropertyName] <String>] [-InputObject <Object>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Path
```
Select-Json.ps1 [[-PropertyName] <String>] -Path <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
'true' |Select-Json.ps1  # default selection is entire parsed JSON document
```

True

### EXAMPLE 2
```
'{"":3.14}' |Select-Json.ps1 /
```

3.14

### EXAMPLE 3
```
'{a:1}' |Select-Json.ps1 /a
```

1

### EXAMPLE 4
```
'{a:1}' |Select-Json.ps1 /b |Measure-Object |Select-Object -ExpandProperty Count  # nothing returned
```

0

### EXAMPLE 5
```
Select-Json.ps1 /powershell.codeFormatting.preset -Path ./.vscode/settings.json
```

Allman

### EXAMPLE 6
```
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Select-Json.ps1 /b/ZZ~1ZZ/AD~0BC
```

7

### EXAMPLE 7
```
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Select-Json.ps1 /b/ZZ~1ZZ
```

Name  Value
----  -----
AD~BC 7

### EXAMPLE 8
```
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |ConvertFrom-Json |Select-Json.ps1 /b/ZZ~1ZZ
```

AD~BC
-----
    7

### EXAMPLE 9
```
'{"a":1, "b": {"ZZ/ZZ": {"AD~BC": 7}}}' |Select-Json.ps1 /b/ZZ~1ZZ |ConvertTo-Json -Compress
```

{"AD~BC":7}

## PARAMETERS

### -PropertyName
The full path name of the property to get, as a JSON Pointer, which separates each nested
element name with a /, and literal / is escaped as ~1, and literal ~ is escaped as ~0.

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

### System.Boolean, System.Int64, System.Double, System.String,
### System.Management.Automation.PSObject, or
### System.Management.Automation.OrderedHashtable (or null) selected from JSON.
## NOTES

## RELATED LINKS

[https://datatracker.ietf.org/doc/html/draft-ietf-appsawg-json-pointer-04](https://datatracker.ietf.org/doc/html/draft-ietf-appsawg-json-pointer-04)

[ConvertFrom-Json]()

