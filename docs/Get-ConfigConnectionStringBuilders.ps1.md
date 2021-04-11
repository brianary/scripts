---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-ConfigConnectionStringBuilders.ps1

## SYNOPSIS
Return named connection string builders for connection strings in a config file.

## SYNTAX

```
Get-ConfigConnectionStringBuilders.ps1 [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ConfigConnectionStringBuilders.ps1 web.Debug.config
```

Returns the connection strings found in the debug web.config XDT.

## PARAMETERS

### -Path
The .NET config file containing connection strings.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String of the path to a .NET config file with connection strings.
## OUTPUTS

### System.Management.Automation.PSCustomObject with the Name and ConnectionString
### (a ConnectionStringBuilder) for each connection string found.
## NOTES

## RELATED LINKS

[Select-Xml]()

