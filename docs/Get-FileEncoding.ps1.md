---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-FileEncoding.ps1

## SYNOPSIS
Returns the encoding for a given file, suitable for passing to encoding parameters.

## SYNTAX

```
Get-FileEncoding.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-FileEncoding.ps1 README.md
```

IsSingleByte      : True
Preamble          :
BodyName          : us-ascii
EncodingName      : US-ASCII
HeaderName        : us-ascii
WebName           : us-ascii
WindowsCodePage   : 1252
IsBrowserDisplay  : False
IsBrowserSave     : False
IsMailNewsDisplay : True
IsMailNewsSave    : True
EncoderFallback   : System.Text.EncoderReplacementFallback
DecoderFallback   : System.Text.DecoderReplacementFallback
IsReadOnly        : True
CodePage          : 20127

## PARAMETERS

### -Path
The path to a file.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Any object with a Path or FullName property to use as the file path.
## OUTPUTS

### System.Text.Encoding (for PowerShell Core),
### or System.String with the encoding name (for legacy Windows PowerShell).
## NOTES

## RELATED LINKS

[Test-FileTypeMagicNumber.ps1]()

