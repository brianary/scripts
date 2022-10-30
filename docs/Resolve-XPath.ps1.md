---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.xml.xmlnode
schema: 2.0.0
---

# Resolve-XPath.ps1

## SYNOPSIS
Returns the XPath of the location of an XML node.

## SYNTAX

```
Resolve-XPath.ps1 [-XmlNode] <XmlNode> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
<b c="value"/></a>' |Select-Xml //@c |Resolve-Xml.ps1
```

/a/b/@c

### EXAMPLE 2
```
one<!-- two -->three</a>' |Select-Xml '//text()' |Resolve-XPath.ps1
```

/a/text()\[1\]
/a/text()\[2\]

## PARAMETERS

### -XmlNode
An XML node to retrieve the XPath for.

```yaml
Type: XmlNode
Parameter Sets: (All)
Aliases: Node

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Xml.XmlNode or property of that type named XmlNode or Node.
## OUTPUTS

### System.Management.Automation.PSCustomObject with the following properties:
### * XPath: The XPath that locates the node.
### * Namespace: The namespace table used to select the node.
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.xml.xmlnode](https://docs.microsoft.com/dotnet/api/system.xml.xmlnode)

