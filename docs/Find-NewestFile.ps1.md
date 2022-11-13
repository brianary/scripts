---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-NewestFile.ps1

## SYNOPSIS
Finds the most recent file.

## SYNTAX

```
Find-NewestFile.ps1 [[-Files] <FileInfo[]>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
ls C:\java.exe -Recurse -ErrorAction Ignore |Find-NewestFile.ps1
```

Directory: C:\Program Files (x86)\Minecraft\runtime\jre-x64\1.8.0_25\bin


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2017-02-05     15:03         190888 java.exe

## PARAMETERS

### -Files
The list of files to search.

```yaml
Type: FileInfo[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.IO.FileInfo[] a list of files to compare.
## OUTPUTS

### System.IO.FileInfo representing the newest of the files compared.
## NOTES

## RELATED LINKS

[Test-NewerFile.ps1]()

