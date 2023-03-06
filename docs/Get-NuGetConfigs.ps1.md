---
external help file: -help.xml
Module Name:
online version: https://docs.myget.org/docs/how-to/nuget-configuration-inheritance
schema: 2.0.0
---

# Get-NuGetConfigs.ps1

## SYNOPSIS
Returns the available NuGet configuration files, in order of preference.

## SYNTAX

```
Get-NuGetConfigs.ps1 [[-Directory] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-NuGetConfigs.ps1
```

C:\Users\zaphodb\GitHub\ProjectX\src\nuget.config
C:\Users\zaphodb\AppData\Roaming\NuGet\NuGet.config
C:\ProgramData\NuGet\Config.config
C:\ProgramData\NuGet\NuGetDefaults.config

## PARAMETERS

### -Directory
The directory to walk the parents of, to look for configs.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: "$PWD"
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String containing the path to a NuGet config file.
## NOTES

## RELATED LINKS

[https://docs.myget.org/docs/how-to/nuget-configuration-inheritance](https://docs.myget.org/docs/how-to/nuget-configuration-inheritance)

