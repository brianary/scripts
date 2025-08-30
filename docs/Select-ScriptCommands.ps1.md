---
external help file: -help.xml
Module Name:
online version: https://learn.microsoft.com/dotnet/api/system.management.automation.language.parser.parsefile
schema: 2.0.0
---

# Select-ScriptCommands.ps1

## SYNOPSIS
Returns the commands used by the specified script.

## SYNTAX

```
Select-ScriptCommands.ps1 [[-Path] <String>] [-CommandType <CommandTypes>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Select-ScriptCommands.ps1 Select-ScriptCommands.ps1
```

CommandType  Name                Version    Source
-----------  ----                -------    ------
Cmdlet       Out-Null            7.5.0.500  Microsoft.PowerShell.Core
Cmdlet       Where-Object        7.5.0.500  Microsoft.PowerShell.Core
Cmdlet       Select-Object       7.0.0.0    Microsoft.PowerShell.Utility
Cmdlet       Get-Command         7.5.0.500  Microsoft.PowerShell.Core
Cmdlet       Resolve-Path        7.0.0.0    Microsoft.PowerShell.Management
Filter       Get-ScriptCommands

## PARAMETERS

### -Path
A script file path (wildcards are accepted).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -CommandType
Specifies the types of commands that this cmdlet gets.

```yaml
Type: CommandTypes
Parameter Sets: (All)
Aliases:
Accepted values: Alias, Function, Filter, Cmdlet, ExternalScript, Application, Script, Configuration, All

Required: False
Position: Named
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

### System.String containing the path to a script file to parse.
## OUTPUTS

### System.Management.Automation.CommandInfo for each command parsed from the file.
## NOTES

## RELATED LINKS

[https://learn.microsoft.com/dotnet/api/system.management.automation.language.parser.parsefile](https://learn.microsoft.com/dotnet/api/system.management.automation.language.parser.parsefile)

[Get-Command]()

