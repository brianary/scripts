---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# ConvertTo-XmlElements.ps1

## SYNOPSIS
Serializes complex content into XML elements.

## SYNTAX

```
ConvertTo-XmlElements.ps1 [[-InputObject] <Object>] [-Depth <Int32>] [-SkipRoot]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-XmlElements.ps1 @{html=@{body=@{p='Some text.'}}}
```

\<html\>\<body\>\<p\>Some text.\</p\>\</body\>\</html\>

### EXAMPLE 2
```
[pscustomobject]@{UserName=$env:USERNAME;Computer=$env:COMPUTERNAME} |ConvertTo-XmlElements.ps1
```

\<Computer\>COMPUTERNAME\</Computer\>
\<UserName\>username\</UserName\>

### EXAMPLE 3
```
Get-ChildItem *.txt |ConvertTo-XmlElements.ps1
```

\<PSPath\>Microsoft.PowerShell.Core\FileSystem::C:\temp\test.txt\</PSPath\>
\<PSParentPath\>Microsoft.PowerShell.Core\FileSystem::C:\scripts\</PSParentPath\>
\<PSChildName\>test.txt\</PSChildName\>
\<PSDrive\>\</PSDrive\>
\<PSProvider\>\</PSProvider\>
\<VersionInfo\>\<FileVersionRaw\>\</FileVersionRaw\>
\<ProductVersionRaw\>\</ProductVersionRaw\>
…

## PARAMETERS

### -InputObject
A hash or XML element or other object to be serialized as XML elements.

Each hash value or object property value may itself be a hash or object or XML element.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Depth
Specifies how many levels of contained objects are included in the JSON representation.
The value can be any number from 0 to 100. The default value is 2.
ConvertTo-Json emits a warning if the number of levels in an input object exceeds this number.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipRoot
Do not wrap the input in a root element.

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

### System.Object (any object) to serialize.
## OUTPUTS

### System.String for each XML-serialized value or property.
## NOTES

## RELATED LINKS
