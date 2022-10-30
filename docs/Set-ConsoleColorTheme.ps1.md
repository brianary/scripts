---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Set-ConsoleColorTheme.ps1

## SYNOPSIS
Overrides ConsoleClass window color palette entries with a preset color theme.

## SYNTAX

```
Set-ConsoleColorTheme.ps1 [-ThemeName] <String> [[-ProcessName] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Set-ConsoleColorTheme.ps1 Dracula
```

(sets the Dracula theme)

## PARAMETERS

### -ThemeName
The name of the theme to set the color table for.

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

### -ProcessName
The name of the process to override the color palette for.
Used to locate the color table under HKCU:\Console\$ProcessName in the registry.

```yaml
Type: String
Parameter Sets: (All)
Aliases: ForProcessName

Required: False
Position: 2
Default value: %SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[Set-ConsoleColors.ps1]()

[https://draculatheme.com/](https://draculatheme.com/)

[https://github.com/dracula/visual-studio-code/blob/master/src/dracula.yml](https://github.com/dracula/visual-studio-code/blob/master/src/dracula.yml)

[https://ethanschoonover.com/solarized/](https://ethanschoonover.com/solarized/)

[https://en.wikipedia.org/wiki/Solarized_(color_scheme)](https://en.wikipedia.org/wiki/Solarized_(color_scheme))

[http://www.kippura.org/zenburnpage/](http://www.kippura.org/zenburnpage/)

[https://github.com/coding-horror/ide-hot-or-not/](https://github.com/coding-horror/ide-hot-or-not/)

[https://studiostyl.es/](https://studiostyl.es/)

