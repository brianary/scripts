---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Format-EscapedUrl.ps1

## SYNOPSIS
Escape URLs more aggressively.

## SYNTAX

### Uri
```
Format-EscapedUrl.ps1 [-Uri] <Uri[]> [<CommonParameters>]
```

### Clipboard
```
Format-EscapedUrl.ps1 [-Clipboard] [<CommonParameters>]
```

## DESCRIPTION
Some characters such as apostrophes and parentheses are legal for URLs,
but are a hassle within certain formats (Markdown, JSON, SQL, &c).

This script URL-escapes these characters to %xx format.

## EXAMPLES

### EXAMPLE 1
```
Format-EscapedUrl.ps1 -Clipboard
```

Updates the URL on the clipboard with a more aggressively escaped version.

### EXAMPLE 2
```
Format-EscapedUrl.ps1 "https://example.com/search(en-US)?q=Name%20%3D%20'System'&sort=y"
```

https://example.com/search%28en-US%29?q=Name%20%3D%20%27System%27&sort=y

## PARAMETERS

### -Uri
The URL to format for maximum compatibility.

```yaml
Type: Uri[]
Parameter Sets: Uri
Aliases: Url

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Clipboard
Indicates that the URL comes from the clipboard, and is updated on the clipboard.

```yaml
Type: SwitchParameter
Parameter Sets: Clipboard
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Uri to escape.
## OUTPUTS

### System.String containing the URL escaped for maximum compatibility.
## NOTES

## RELATED LINKS
