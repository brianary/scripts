---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Copy-SchTasks.ps1

## SYNOPSIS
Copy scheduled jobs from another computer to this one, using a GUI list to choose jobs.

## SYNTAX

```
Copy-SchTasks.ps1 [-ComputerName] <String> [[-DestinationComputerName] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Copy-SchTasks.ps1 SourceComputer DestComputer
```

Attempts to copy tasks from SourceComputer to DestComputer.

## PARAMETERS

### -ComputerName
The name of the computer to copy jobs from.

```yaml
Type: String
Parameter Sets: (All)
Aliases: CN, Source

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DestinationComputerName
The name of the computer to copy jobs to (local computer by default).

```yaml
Type: String
Parameter Sets: (All)
Aliases: To, Destination

Required: False
Position: 2
Default value: $env:COMPUTERNAME
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

### System.Void
## NOTES

## RELATED LINKS
