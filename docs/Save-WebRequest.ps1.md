---
external help file: -help.xml
Module Name:
online version: https://tools.ietf.org/html/rfc2183
schema: 2.0.0
---

# Save-WebRequest.ps1

## SYNOPSIS
Downloads a given URL to a file, automatically determining the filename.

## SYNTAX

```
Save-WebRequest.ps1 [-Uri] <Uri> [-CreationTime <DateTime>] [-LastWriteTime <DateTime>] [-Open]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Save-WebRequest.ps1 https://www.irs.gov/pub/irs-pdf/f1040.pdf -Open
```

Saves f1040.pdf (or else a filename specified in the Content-Disposition header) and opens it.

## PARAMETERS

### -Uri
The URL to download.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: Url

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CreationTime
Sets the creation time on the file to the given value.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastWriteTime
Sets the creation time on the file to the given value.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Open
When present, invokes the file after it is downloaded.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Object with System.Uri property named Uri.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[https://tools.ietf.org/html/rfc2183](https://tools.ietf.org/html/rfc2183)

[http://test.greenbytes.de/tech/tc2231/](http://test.greenbytes.de/tech/tc2231/)

[https://msdn.microsoft.com/library/system.net.mime.contentdisposition.filename.aspx](https://msdn.microsoft.com/library/system.net.mime.contentdisposition.filename.aspx)

[https://msdn.microsoft.com/library/system.io.path.getinvalidfilenamechars.aspx](https://msdn.microsoft.com/library/system.io.path.getinvalidfilenamechars.aspx)

[Invoke-WebRequest]()

[Invoke-Item]()

[Move-Item]()

