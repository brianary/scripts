---
external help file: -help.xml
Module Name:
online version: https://stackoverflow.com/a/26786080/54323
schema: 2.0.0
---

# Get-XmlNamespaces.ps1

## SYNOPSIS
Gets the namespaces from a document as a dictionary.

## SYNTAX

```
Get-XmlNamespaces.ps1 [-Path] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Select-Xml /xsl:transform .\dataref.xslt -Namespace (Get-XmlNamespaces.ps1 .\dataref.xslt)
```

Node      Path                                       Pattern
----      ----                                       -------
transform C:\Users\brian\GitHub\scripts\dataref.xslt /xsl:transform

### EXAMPLE 2
```
Get-XmlNamespaces.ps1 .\dataref.xslt
```

Key     Value
---     -----
xml     http://www.w3.org/XML/1998/namespace
xsl     http://www.w3.org/1999/XSL/Transform
xs      http://www.w3.org/2001/XMLSchema
x       urn:guid:f203a737-cebb-419d-9fbe-a684f1f13591
wsdl    http://schemas.xmlsoap.org/wsdl/
        http://www.w3.org/1999/xhtml

## PARAMETERS

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

## OUTPUTS

### System.Collections.Generic.Dictionary[System.String,System.String] containing namespace
### prefixes as keys and namespace URIs as values.
## NOTES

## RELATED LINKS

[https://stackoverflow.com/a/26786080/54323](https://stackoverflow.com/a/26786080/54323)

