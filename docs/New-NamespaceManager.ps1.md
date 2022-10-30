---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.xml.xmlnamespacemanager
schema: 2.0.0
---

# New-NamespaceManager.ps1

## SYNOPSIS
Creates an object to lookup XML namespace prefixes.

## SYNTAX

```
New-NamespaceManager.ps1 [[-Namespaces] <IDictionary>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Use-ReasonableDefaults.ps1; $n = New-NamespaceManager.ps1; (Select-Xml //xhtml:td dataref.xslt).Node.SelectSingleNode('xhtml:var',$n).OuterXml
```

\<var xmlns="http://www.w3.org/1999/xhtml"\>ANY\</var\>
\<var xmlns="http://www.w3.org/1999/xhtml"\>ANY\</var\>

## PARAMETERS

### -Namespaces
A dictionary of prefixes and their namespace URLs.
If a default Namespace value for Select-Xml exists, this will use it.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $PSDefaultParameterValues['Select-Xml:Namespace']
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Xml.XmlNamespaceManager containing the given namespaces.
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.xml.xmlnamespacemanager](https://docs.microsoft.com/dotnet/api/system.xml.xmlnamespacemanager)

