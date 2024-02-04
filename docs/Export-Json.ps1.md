---
external help file: -help.xml
Module Name:
online version: http://jsonref.org/
schema: 2.0.0
---

# Export-Json.ps1

## SYNOPSIS
Exports a portion of a JSON document, recursively importing references.

## SYNTAX

### InputObject
```
Export-Json.ps1 [[-JsonPointer] <String>] [-InputObject <Object>] [-Compress]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Path
```
Export-Json.ps1 [[-JsonPointer] <String>] -Path <String> [-Compress] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
'{d:{a:{b:1,c:{"$ref":"#/d/two"}},two:2}}' |Export-Json.ps1 /d/a
```

{
  "b": 1,
  "c": 2
}

### EXAMPLE 2
```
'{d:{a:{b:1,c:{"$ref":"#/d/c"}},c:{d:{"$ref":"#/d/two"}},two:2}}' |Export-Json.ps1 /d/a
```

{
  "b": 1,
  "c": {
    "d": 2
  }
}

## PARAMETERS

### -JsonPointer
The full path name of the property to get, as a JSON Pointer, modified to support wildcards:
~0 = ~  ~1 = /  ~2 = ?  ~3 = *  ~4 = [

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

### System.String containing the extracted JSON.
## NOTES

## RELATED LINKS

[http://jsonref.org/](http://jsonref.org/)

[https://www.rfc-editor.org/rfc/rfc6901](https://www.rfc-editor.org/rfc/rfc6901)

