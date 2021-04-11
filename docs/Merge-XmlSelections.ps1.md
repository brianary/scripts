---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Merge-XmlSelections.ps1

## SYNOPSIS
Builds an object using the named XPath selections as properties.

## SYNTAX

### Xml
```
Merge-XmlSelections.ps1 [-XPaths] <IDictionary> [-Xml] <XmlNode[]> [-Namespace <Hashtable>]
 [<CommonParameters>]
```

### Path
```
Merge-XmlSelections.ps1 [-XPaths] <IDictionary> [-Path] <String[]> [-Namespace <Hashtable>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Merge-XmlSelections.ps1 @{Version='/*/@version';Format='/xsl:output/@method'} *.xsl* -Namespace @{xsl='http://www.w3.org/1999/XSL/Transform'}
```

Path                    Version Format
----                    ------- ------
Z:\Scripts\dataref.xslt 2.0     html
Z:\Scripts\xhtml2fo.xsl 1.0     xml

## PARAMETERS

### -XPaths
Any dictionary or hashtable of property name to XPath to select a value with.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Xml
The XML to select the property values from.

```yaml
Type: XmlNode[]
Parameter Sets: Xml
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Path
XML file(s) to select the property values from.

```yaml
Type: String[]
Parameter Sets: Path
Aliases: FullName

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Namespace
{{ Fill Namespace Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PSDefaultParameterValues['Select-Xml:Namespace']
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Xml.XmlNode of XML or System.String of XML file names to select property values from.
## OUTPUTS

### System.Management.Automation.PSCustomObject object with the selected properties.
## NOTES

## RELATED LINKS

[Select-XmlNodeValue.ps1]()

