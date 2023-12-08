---
external help file: -help.xml
Module Name:
online version: https://www.w3.org/TR/xmlschema-1/#xsi_schemaLocation
schema: 2.0.0
---

# Test-Xml.ps1

## SYNOPSIS
Try parsing text as XML, and validating it if a schema is provided.

## SYNTAX

### Path
```
Test-Xml.ps1 [-Path] <String> [-Schemata <Hashtable>] [-SkipValidation] [-Warnings] [-ErrorMessage]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Xml
```
Test-Xml.ps1 -Xml <String> [-Schemata <Hashtable>] [-SkipValidation] [-Warnings] [-ErrorMessage]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
'
```

False

## PARAMETERS

### -Path
A file to check.

```yaml
Type: String
Parameter Sets: Path
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Xml
The string to check.

```yaml
Type: String
Parameter Sets: Xml
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Schemata
A hashtable of schema namespaces to schema locations (in addition to the xsi:schemaLocation attribute).

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: Schemas

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipValidation
Indicates that XML Schema validation should not be performed, only XML well-formedness will be checked.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: NoValidation

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Warnings
{{ Fill Warnings Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: ShowWarnings

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ErrorMessage
When present, returns the well-formedness or validation error messages instead of a boolean value,
or nothing if successful.
This effectively reverses the truthiness of the return value.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: NotSuccessful

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

### System.String containing a file path or potential XML data.
## OUTPUTS

### System.Boolean indicating the XML is parseable, or System.String containing the
### parse error if -ErrorMessage is present and the XML isn't parseable.
## NOTES

## RELATED LINKS

[https://www.w3.org/TR/xmlschema-1/#xsi_schemaLocation](https://www.w3.org/TR/xmlschema-1/#xsi_schemaLocation)

[https://docs.microsoft.com/dotnet/api/system.xml.xmlresolver](https://docs.microsoft.com/dotnet/api/system.xml.xmlresolver)

[https://docs.microsoft.com/dotnet/api/system.xml.schema.validationeventhandler](https://docs.microsoft.com/dotnet/api/system.xml.schema.validationeventhandler)

[Resolve-XmlSchemaLocation.ps1]()

