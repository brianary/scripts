---
external help file: -help.xml
Module Name:
online version: https://aka.ms/terminal-documentation
schema: 2.0.0
---

# Set-TerminalProfile.ps1

## SYNOPSIS
Adds or updates a Windows Terminal command profile.

## SYNTAX

```
Set-TerminalProfile.ps1 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Set-TerminalProfile.ps1 pwsh
```

Adds a default profile for PowerShell Core.

### EXAMPLE 2
```
Set-TerminalProfile.ps1 fsi
```

Adds a default profile for F# Interactive.

### EXAMPLE 3
```
Set-TerminalProfile.ps1 ssh servername 'ssh username@servername'
```

Adds an ssh profile named "servername", using the specified command line.

## PARAMETERS

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

## RELATED LINKS

[https://aka.ms/terminal-documentation](https://aka.ms/terminal-documentation)

[https://aka.ms/terminal-profiles-schema](https://aka.ms/terminal-profiles-schema)

[https://gist.github.com/shanselman/4d954449914664024ee20ba10c2aaa0d](https://gist.github.com/shanselman/4d954449914664024ee20ba10c2aaa0d)

[https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions](https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions)

[https://github.com/microsoft/terminal/issues/1918#issuecomment-2452815871](https://github.com/microsoft/terminal/issues/1918#issuecomment-2452815871)

