---
external help file: -help.xml
Module Name:
online version: https://www.w3.org/TR/xmlschema-1/#schema-loc
schema: 2.0.0
---

# Resolve-XmlSchemaLocation.ps1

## SYNOPSIS
Gets the namespaces and their URIs and URLs from a document.

## SYNTAX

### Xml
```
Resolve-XmlSchemaLocation.ps1 [-Xml] <XmlDocument> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Path
```
Resolve-XmlSchemaLocation.ps1 [-Path] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Resolve-XmlSchemaLocation.ps1 test.xml
```

Path  : C:\test.xml
Node  : root
Alias : xml
Urn   : http://www.w3.org/XML/1998/namespace
Url   :

Path  : C:\test.xml
Node  : root
Alias : xsi
Urn   : http://www.w3.org/2001/XMLSchema-instance
Url   :

## PARAMETERS

### -Xml
The string to check.

```yaml
Type: XmlDocument
Parameter Sets: Xml
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
A file to check.

```yaml
Type: String
Parameter Sets: Path
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### System.Xml.XmlDocument or System.String containing the path to an XML file.
## OUTPUTS

### System.Management.Automation.PSCustomObject for each namespace, with Path,
### Node, Alias, Urn, and Url properties.
## NOTES

## RELATED LINKS

[https://www.w3.org/TR/xmlschema-1/#schema-loc](https://www.w3.org/TR/xmlschema-1/#schema-loc)

[https://stackoverflow.com/a/26786080/54323](https://stackoverflow.com/a/26786080/54323)

