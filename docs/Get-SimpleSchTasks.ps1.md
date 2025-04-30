---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-SimpleSchTasks.ps1

## SYNOPSIS
Returns simple scheduled task info.

## SYNTAX

```
Get-SimpleSchTasks.ps1 [[-TaskName] <String[]>] [[-TaskPath] <String[]>] [-NonInteractive]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SimpleSchTasks.ps1 -TaskPath \ -NonInteractive
```

Returns a simplified list of tasks for the local system that are not set to run interactively.

## PARAMETERS

### -TaskName
Specifies an array of one or more names of a scheduled task.
You can use "*" for a wildcard character query.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskPath
Specifies an array of one or more paths for scheduled tasks in Task Scheduler namespace.
You can use "*" for a wildcard character query.
You can use \ for the root folder.
To specify a full TaskPath you need to include the leading and trailing \ *.
If you do not specify a path, the cmdlet uses the root folder.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NonInteractive
Exclude tasks that are set to run interactively, include only tasks with credentials set.

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
