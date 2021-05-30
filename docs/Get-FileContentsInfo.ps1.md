---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-FileContentsInfo.ps1

## SYNOPSIS
Returns whether the file is binary or text, and what encoding, line endings, and indents text files contain.

## SYNTAX

```
Get-FileContentsInfo.ps1 [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-FileContentsInfo.ps1 Get-FileContentsInfo.ps1
```

Path        : A:\Scripts\Get-FileContentsInfo.ps1
IsBinary    : False
Encoding    : System.Text.ASCIIEncoding+ASCIIEncodingSealed
LineEndings : CRLF
Indents     : Tabs

## PARAMETERS

### -Path
The location of a file.

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

### Any object with a Path or FullName property to use for a file location.
## OUTPUTS

### System.Management.Automation.PSObject with the following properties:
### * Path the full path of the file.
### * IsBinary indicates a binary (vs text) file.
### * Encoding contains the encoding of a text file.
### * LineEndings indicates the type of line endings used in a text file.
### * Indents indicates the type of indent characters used in a text file.
## NOTES

## RELATED LINKS
