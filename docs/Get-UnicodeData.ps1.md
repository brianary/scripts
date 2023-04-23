---
external help file: -help.xml
Module Name:
online version: https://www.unicode.org/L2/L1999/UnicodeData.html
schema: 2.0.0
---

# Get-UnicodeData.ps1

## SYNOPSIS
Returns the current (cached) Unicode character data.

## SYNTAX

```
Get-UnicodeData.ps1 [[-Url] <Uri>] [[-DataFile] <String>] [<CommonParameters>]
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

### -Url
The location of the latest Unicode data.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataFile
{{ Fill DataFile Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Join-Path $env:TEMP ($Url.Segments[-1]))
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject for each character entry with these properties:
## NOTES

## RELATED LINKS

[https://www.unicode.org/L2/L1999/UnicodeData.html](https://www.unicode.org/L2/L1999/UnicodeData.html)

