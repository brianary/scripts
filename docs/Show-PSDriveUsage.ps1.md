---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Show-PSDriveUsage.ps1

## SYNOPSIS
Displays drive usage graphically, and with a human-readable summary.

## SYNTAX

```
Show-PSDriveUsage.ps1 [[-Name] <String[]>] [-AsAscii] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Show-PSDriveUsage.ps1 C -AsAscii
```

#################_______________________________________________________________________
C:\ Windows \[NTFS\] 953GB = 762GB (79%) free + 191GB (20%) used

### EXAMPLE 2
```
Show-PSDriveUsage.ps1 /home -AsAscii
###################_____________________________________________________________________
/home [ext3] 4TB = 3TB (73%) free + 792GB (21%) used
```

## PARAMETERS

### -Name
A drive name to display the usage for.
All ready fixed drives are displayed if none is specified.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: @()
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AsAscii
Display the graph as ASCII.

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

### An object with a Name property that corresponds to a drive name.
## OUTPUTS

## NOTES

## RELATED LINKS

[Import-CharConstants.ps1]()

[Format-ByteUnits.ps1]()

[Write-Info.ps1]()

