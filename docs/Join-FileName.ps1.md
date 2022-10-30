---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Join-FileName.ps1

## SYNOPSIS
Combines a filename with a string.

## SYNTAX

```
Join-FileName.ps1 [-Path] <String> [-AppendText] <String> [<CommonParameters>]
```

## DESCRIPTION
Join-FileName appends a string to a filename, including a new extension 
overwrites the filename's extension.

## EXAMPLES

### EXAMPLE 1
```
Join-FileName.ps1 activity.log '-20161111'
```

activity-20161111.log

### EXAMPLE 2
```
Join-FileName.ps1 readme.txt .bak
```

readme.bak

### EXAMPLE 3
```
Join-FileName.ps1 C:\temp\activity.log .27.old
```

C:\temp\activity.27.old

## PARAMETERS

### -Path
The path to a file.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -AppendText
Text to append to the filename, either before the extension or including one.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Extension

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String file path.
## OUTPUTS

### System.String file path with appended text.
## NOTES

## RELATED LINKS
