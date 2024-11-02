---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Get-ConsoleHistory.ps1

## SYNOPSIS
Returns the DOSKey-style console command history (up arrow or F8).

## SYNTAX

### Id
```
Get-ConsoleHistory.ps1 -Id <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Like
```
Get-ConsoleHistory.ps1 -Like <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Match
```
Get-ConsoleHistory.ps1 -Match <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### All
```
Get-ConsoleHistory.ps1 [-All] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ConsoleHistory.ps1 |where CommandLine -like *readme*
```

Id CommandLine
-- -----------
30 gc .\README.md
56 gc .\README.md

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

### -Match
{{ Fill Match Description }}

```yaml
Type: String
Parameter Sets: Match
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
{{ Fill All Description }}

```yaml
Type: SwitchParameter
Parameter Sets: All
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

### System.Management.Automation.PSObject with these properties:
### * Id: The position of the command in the console history.
### * CommandLine: The command entered in the history.
## NOTES

## RELATED LINKS
