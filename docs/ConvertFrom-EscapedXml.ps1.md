---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# ConvertFrom-EscapedXml.ps1

## SYNOPSIS
Parse escaped XML into XML and serialize it.

## SYNTAX

```
ConvertFrom-EscapedXml.ps1 [-EscapedXml] <String> [-Compress] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
ConvertFrom-EscapedXml.ps1 '&lt;a href=&quot;http://example.org&quot;&gt;link&lt;/a&gt;'
```

\<a href="http://example.org"\>link\</a\>

## PARAMETERS

### -EscapedXml
The escaped XML text.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Compress
{{ Fill Compress Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: NoIndent

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String, some escaped XML.
## OUTPUTS

### System.String, the XML parsed and serialized.
## NOTES

## RELATED LINKS
