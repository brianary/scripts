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

```
Export-Json.ps1 [[-PropertyName] <String>] [-InputObject <Object>] [-ProgressAction <ActionPreference>]
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
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
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

