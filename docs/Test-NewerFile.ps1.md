---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-NewerFile.ps1

## SYNOPSIS
Returns true if the difference file is newer than the reference file.

## SYNTAX

```
Test-NewerFile.ps1 [[-ReferenceFile] <FileInfo>] [[-DifferenceFile] <FileInfo>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ReferenceFile
One of two files to compare.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DifferenceFile
Another of two files to compare.

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean indicating the difference file is newer.
## NOTES

## RELATED LINKS
