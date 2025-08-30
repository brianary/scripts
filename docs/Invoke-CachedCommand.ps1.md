---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Invoke-CachedCommand.ps1

## SYNOPSIS
Caches the output of a command for recall if called again.

## SYNTAX

### ExpiresAfter
```
Invoke-CachedCommand.ps1 [-Expression] <ScriptBlock> [[-BlockArgs] <PSObject[]>] [-ExpiresAfter <TimeSpan>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Expires
```
Invoke-CachedCommand.ps1 [-Expression] <ScriptBlock> [[-BlockArgs] <PSObject[]>] [-Expires <DateTime>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Session
```
Invoke-CachedCommand.ps1 [-Expression] <ScriptBlock> [[-BlockArgs] <PSObject[]>] [-Session]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Invoke-CachedCommand.ps1 {Invoke-RestMethod https://example.org/endpoint} -Session
```

Returns the result of executing the script block, or the previous cached output if available.

## PARAMETERS

### -Expression
Specifies the expression to cache the output of.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BlockArgs
Parameters to the script block.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpiresAfter
The rolling duration to cache the output for (updated with each call).

```yaml
Type: TimeSpan
Parameter Sets: ExpiresAfter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Expires
Point in time to cache the output until.

```yaml
Type: DateTime
Parameter Sets: Expires
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Session
Caches the output for this session.

```yaml
Type: SwitchParameter
Parameter Sets: Session
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

## OUTPUTS

## NOTES

## RELATED LINKS
