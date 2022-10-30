---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Convert-Xml.ps1

## SYNOPSIS
Transform XML using an XSLT template.

## SYNTAX

### Xml
```
Convert-Xml.ps1 [-TransformXslt] <XmlDocument> [[-Xml] <XmlDocument>] [-OutFile <String>] [-TrustedXslt]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### File
```
Convert-Xml.ps1 -TransformFile <String> [-Path <String>] [-OutFile <String>] [-TrustedXslt] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
' '<z/>' |Format-Xml.ps1
```

\<a /\>

### EXAMPLE 2
```
Convert-Xml.ps1 xsd2html.xslt schema.xsd schema.html
```

(Writes schema.html)

## PARAMETERS

### -TransformXslt
An XML document containing an XSLT transform.

```yaml
Type: XmlDocument
Parameter Sets: Xml
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Xml
An XML document to transform.

```yaml
Type: XmlDocument
Parameter Sets: Xml
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -TransformFile
The XSLT file to use to transform the XML.

```yaml
Type: String
Parameter Sets: File
Aliases: TemplateFile, XsltTemplateFile

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The XML file to transform.

```yaml
Type: String
Parameter Sets: File
Aliases: XmlFile, FullName

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -OutFile
The file to write the transformed XML to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TrustedXslt
When specified, indicates the XSLT is trusted, enabling the document()
function and embedded script blocks.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
### System.Void
## NOTES

## RELATED LINKS
