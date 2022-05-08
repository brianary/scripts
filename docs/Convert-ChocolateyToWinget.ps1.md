---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Convert-ChocolateyToWinget.ps1

## SYNOPSIS
Change from managing various packages with Chocolatey to WinGet.

## SYNTAX

```
Convert-ChocolateyToWinget.ps1 [[-PackageName] <String[]>] [-SkipPackages <String[]>] [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Convert-ChocolateyToWinget.ps1 -SkipPackages autohotkey,git
```

Moves package management from Chocolatey to WinGet for everything except
autohotkey (maybey you are managing Adobe Digital Editions with Chocolatey),
or git (maybe you are managing PoshGit with Chocolatey).

## PARAMETERS

### -PackageName
A specific package to convert

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -SkipPackages
Chocolatey packages to skip.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Fully uninstalls the Chocolatey package before installing the corresponding winget package,
instead of simply removing the package from the Chocolatey package list.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

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

## RELATED LINKS
