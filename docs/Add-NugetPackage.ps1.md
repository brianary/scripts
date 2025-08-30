---
external help file: -help.xml
Module Name:
online version: https://www.nuget.org/
schema: 2.0.0
---

# Add-NugetPackage.ps1

## SYNOPSIS
Loads a NuGet package DLL, downloading as needed.

## SYNTAX

```
Add-NugetPackage.ps1 [-PackageName] <String> [[-TypeName] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Add-NugetPackage.ps1 Serilog ; [Serilog.Core.Logger]::None -is [Serilog.ILogger]
```

True

## PARAMETERS

### -PackageName
The name of the NuGet package to load.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName
Use this type name to test whether the package was loaded.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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

## OUTPUTS

## NOTES
Install-Package isn't working for arbitrary NuGet packages, so this allows us access the main DLL
assembly and types within the package.

## RELATED LINKS

[https://www.nuget.org/](https://www.nuget.org/)

