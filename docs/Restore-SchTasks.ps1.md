---
external help file: -help.xml
Module Name:
online version: https://msdn.microsoft.com/library/windows/desktop/bb736357.aspx
schema: 2.0.0
---

# Restore-SchTasks.ps1

## SYNOPSIS
Imports from a single XML file into the local Scheduled Tasks.

## SYNTAX

```
Restore-SchTasks.ps1 [[-Path] <String>] [-Exclude <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Restore-SchTasks.ps1
```

(Imports scheduled tasks from tasks.xml, prompting for passwords as needed.)

## PARAMETERS

### -Path
The file to import tasks from, as exported from Backup-SchTasks.ps1.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Tasks.xml
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
A wildcard pattern to match task "paths" (including folders) to skip.

User tasks are usually just in the root, and generally machine-specific
tasks Microsoft automatically sets up are in folders so this is *\* by
default to exclude the weird magic tasks.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *\*
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

[https://msdn.microsoft.com/library/windows/desktop/bb736357.aspx](https://msdn.microsoft.com/library/windows/desktop/bb736357.aspx)

[Select-Xml]()

[Get-Credential]()

