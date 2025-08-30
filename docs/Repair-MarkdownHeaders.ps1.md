---
external help file: -help.xml
Module Name:
online version: https://webcoder.info/markdown-headers.html
schema: 2.0.0
---

# Repair-MarkdownHeaders.ps1

## SYNOPSIS
Updates markdown content to replace level 1 & 2 ATX headers to Setext headers.

## SYNTAX

### Path
```
Repair-MarkdownHeaders.ps1 [-Path] <String> [[-Encoding] <String>] [-Style <String>] [-NewLine <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### InputObject
```
Repair-MarkdownHeaders.ps1 [-InputObject <String>] [-Style <String>] [-NewLine <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Repair-MarkdownHeaders.ps1 -Path readme.md -Style SetextWithAtx
```

Updates the file with the specified header style.

### EXAMPLE 2
```
$content = $markdown |Repair-MarkdownHeaders.ps1 -Style Atx
```

Returns markdown code that uses ATX headers.

## PARAMETERS

### -Path
Markdown file to update.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Encoding
The text encoding to use when converting text to binary data.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: False
Position: 2
Default value: Utf8
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
Markdown content to update.

```yaml
Type: String
Parameter Sets: InputObject
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Style
The style of headers to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: SetextWithAtx
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewLine
The line endings to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [Environment]::NewLine
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

### System.String containing markdown code to update.
## OUTPUTS

### System.String containing updated markdown code.
## NOTES

## RELATED LINKS

[https://webcoder.info/markdown-headers.html](https://webcoder.info/markdown-headers.html)

