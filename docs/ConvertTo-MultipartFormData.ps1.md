---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/api/system.net.http.multipartformdatacontent
schema: 2.0.0
---

# ConvertTo-MultipartFormData.ps1

## SYNOPSIS
Creates multipart/form-data to send as a request body.

## SYNTAX

```
ConvertTo-MultipartFormData.ps1 [-Fields] <IDictionary> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
@{ title = 'Name'; file = Get-Item avartar.png } |ConvertTo-MultipartFormData.ps1 |Invoke-WebRequest $url -Method POST
```

Sends two fields, one of which is a file upload.

## PARAMETERS

### -Fields
The fields to pass, as a Hashtable or other dictionary.
Values of the System.IO.FileInfo type will be read, as for a file upload.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Any System.Collections.IDictionary type of key-value pairs to encode.
## OUTPUTS

### System.Byte[] of encoded key-value data.
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/api/system.net.http.multipartformdatacontent](https://docs.microsoft.com/dotnet/api/system.net.http.multipartformdatacontent)

[Invoke-WebRequest]()

[Invoke-RestMethod]()

[New-Guid]()

