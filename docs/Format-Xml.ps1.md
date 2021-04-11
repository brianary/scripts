---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Format-Xml.ps1

## SYNOPSIS
Pretty-print XML.

## SYNTAX

```
Format-Xml.ps1 [-Xml] <XmlDocument> [-IndentChar <Char>] [-Indentation <Int32>] [-NewLineOnAttributes]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-PSProvider alias |ConvertTo-Xml |Format-Xml.ps1
```

\<Objects\>
  \<Object Type="System.Management.Automation.ProviderInfo"\>
    \<Property Name="ImplementingType" Type="System.RuntimeType"\>Microsoft.PowerShell.Commands.AliasProvider\</Property\>
    \<Property Name="HelpFile" Type="System.String"\>System.Management.Automation.dll-Help.xml\</Property\>
    \<Property Name="Name" Type="System.String"\>Alias\</Property\>
    \<Property Name="PSSnapIn" Type="System.Management.Automation.PSSnapInInfo"\>Microsoft.PowerShell.Core\</Property\>
    \<Property Name="ModuleName" Type="System.String"\>Microsoft.PowerShell.Core\</Property\>
    \<Property Name="Module" Type="System.Management.Automation.PSModuleInfo" /\>
    \<Property Name="Description" Type="System.String"\>\</Property\>
    \<Property Name="Capabilities" Type="System.Management.Automation.Provider.ProviderCapabilities"\>ShouldProcess\</Property\>
    \<Property Name="Home" Type="System.String"\>\</Property\>
    \<Property Name="Drives" Type="System.Collections.ObjectModel.Collection\`1\[System.Management.Automation.PSDriveInfo\]"\>
      \<Property Type="System.Management.Automation.PSDriveInfo"\>Alias\</Property\>
    \</Property\>
  \</Object\>
\</Objects\>

### EXAMPLE 2
```
Get-PSProvider alias |ConvertTo-Xml |Format-Xml.ps1 -NewLineOnAttributes
```

\<Objects\>
  \<Object
    Type="System.Management.Automation.ProviderInfo"\>
    \<Property
      Name="ImplementingType"
      Type="System.RuntimeType"\>Microsoft.PowerShell.Commands.AliasProvider\</Property\>
    \<Property
      Name="HelpFile"
      Type="System.String"\>System.Management.Automation.dll-Help.xml\</Property\>
    \<Property
      Name="Name"
      Type="System.String"\>Alias\</Property\>
    \<Property
      Name="PSSnapIn"
      Type="System.Management.Automation.PSSnapInInfo"\>Microsoft.PowerShell.Core\</Property\>
    \<Property
      Name="ModuleName"
      Type="System.String"\>Microsoft.PowerShell.Core\</Property\>
    \<Property
      Name="Module"
      Type="System.Management.Automation.PSModuleInfo" /\>
    \<Property
      Name="Description"
      Type="System.String"\>\</Property\>
    \<Property
      Name="Capabilities"
      Type="System.Management.Automation.Provider.ProviderCapabilities"\>ShouldProcess\</Property\>
    \<Property
      Name="Home"
      Type="System.String"\>\</Property\>
    \<Property
      Name="Drives"
      Type="System.Collections.ObjectModel.Collection\`1\[System.Management.Automation.PSDriveInfo\]"\>
      \<Property
        Type="System.Management.Automation.PSDriveInfo"\>Alias\</Property\>
    \</Property\>
  \</Object\>
\</Objects\>

## PARAMETERS

### -Xml
The XML string or document to format.

```yaml
Type: XmlDocument
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -IndentChar
A whitespace indent character to use, space by default.

```yaml
Type: Char
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Indentation
The number of IndentChars to use per level of indent, 2 by default.
Set to zero for no indentation.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewLineOnAttributes
Indicates attributes should be written on a new line.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: SplitAttributes, AttributesSeparated

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Xml.XmlDocument to serialize.
## OUTPUTS

### System.String containing the serialized XML document with desired indents.
## NOTES

## RELATED LINKS
