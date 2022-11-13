---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-ProjectPackages.ps1

## SYNOPSIS
Find modules used in projects.

## SYNTAX

```
Find-ProjectPackages.ps1 [-PackageName] <String> [-Path <String>] [-MinVersion <Version>]
 [-MaxVersion <Version>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Find-ProjectModule.ps1 jQuery*
```

Name               Version File
----               ------- ----
jquery.datatables  1.10.9  C:\Repo\packages.config
jQuery             1.7     C:\Repo\packages.config
jQuery             1.8.3   C:\OtherRepo\packages.config

## PARAMETERS

### -PackageName
The name of a package to search for.
Wildcards (as supported by -like) are allowed.

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

### -Path
The path of a folder to search within.
Uses the current working directory ($PWD) by default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $PWD
Accept pipeline input: False
Accept wildcard characters: False
```

### -MinVersion
The minimum (inclusive) version of the package to return.

```yaml
Type: Version
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxVersion
The maximum (inclusive) version of the package to return.

```yaml
Type: Version
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String containing a package name (wildcards supported).
## OUTPUTS

### System.Management.Automation.PSCustomObject each with properties for the Name,
### Version, and File of packages found.
## NOTES

## RELATED LINKS

[Select-Xml]()

[ConvertFrom-Json]()

