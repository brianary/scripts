---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Remove-ConsoleHistory.ps1

## SYNOPSIS
Removes an entry from the DOSKey-style console command history (up arrow or F8).

## SYNTAX

### Id
```
Remove-ConsoleHistory.ps1 -Id <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### CommandLine
```
Remove-ConsoleHistory.ps1 [-CommandLine] <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Like
```
Remove-ConsoleHistory.ps1 -Like <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Duplicates
```
Remove-ConsoleHistory.ps1 [-Duplicates] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Remove-ConsoleHistory.ps1 -Id 42
```

Deletes the 42nd command from the history.

### EXAMPLE 2
```
Remove-ConsoleHistory.ps1 -Duplicates
```

Deletes any repeated commands from the history.

### EXAMPLE 3
```
Remove-ConsoleHistory.ps1 -Like winget*
```

Deletes any commands that start with "winget" from the history.

## PARAMETERS

### -Id
{{ Fill Id Description }}

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandLine
{{ Fill CommandLine Description }}

```yaml
Type: String
Parameter Sets: CommandLine
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Like
{{ Fill Like Description }}

```yaml
Type: String
Parameter Sets: Like
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Duplicates
{{ Fill Duplicates Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Duplicates
Aliases:

Required: True
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

### System.String containing exact commands to remove.
## OUTPUTS

## NOTES

## RELATED LINKS
