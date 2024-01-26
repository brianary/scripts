---
external help file: -help.xml
Module Name:
online version: https://datatracker.ietf.org/doc/html/draft-ietf-appsawg-json-pointer-04
schema: 2.0.0
---

# Set-Json.ps1

## SYNOPSIS
Sets a property in a JSON string or file.

## SYNTAX

### InputObject
```
Set-Json.ps1 [[-PropertyName] <String>] [-PropertyValue] <PSObject> [-WarnOverwrite] -InputObject <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Path
```
Set-Json.ps1 [[-PropertyName] <String>] [-PropertyValue] <PSObject> [-WarnOverwrite] -Path <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
'0' |Set-Json.ps1 -PropertyValue $true
```

true

### EXAMPLE 2
```
'{}' |Set-Json.ps1 / $false
```

{
  "": false
}

### EXAMPLE 3
```
'{}' |Set-Json.ps1 /~1/~0 3.14
```

{
  "/": {
    "~": 3.14
  }
}

### EXAMPLE 4
```
'{a:1}' |Set-Json.ps1 /b/ZZ~1ZZ/AD~0BC 7
```

{
  "a": 1,
  "b": {
    "ZZ/ZZ": {
      "AD~BC": 7
    }
  }
}

### EXAMPLE 5
```
Set-Json.ps1 /powershell.codeFormatting.preset Allman -Path ./.vscode/settings.json
```

Sets "powershell.codeFormatting.preset": "Allman" within the ./.vscode/settings.json file.

## PARAMETERS

### -PropertyName
The full path name of the property to set, as a JSON Pointer, which separates each nested
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

### -PropertyValue
The value to set the property to.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases: Value

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WarnOverwrite
Indicates that overwriting values should generate a warning.

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

### -InputObject
The JSON string to set the property in.

```yaml
Type: String
Parameter Sets: InputObject
Aliases:

Required: True
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

### System.String containing JSON.
## OUTPUTS

### System.String containing updated JSON (unless a file is specified, which is updated).
## NOTES

## RELATED LINKS

[https://datatracker.ietf.org/doc/html/draft-ietf-appsawg-json-pointer-04](https://datatracker.ietf.org/doc/html/draft-ietf-appsawg-json-pointer-04)

[ConvertFrom-Json]()

[ConvertTo-Json]()

[Add-Member]()

