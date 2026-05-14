---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Trace-WebRequest.ps1

## SYNOPSIS
Provides details about a retrieving a URI.

## SYNTAX

```
Trace-WebRequest.ps1 [-Uri] <Uri> [-Method <HttpMethod>] [-LogFile <String>] [-SkipHeaders] [-SkipContent]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Trace-WebRequest.ps1 g.co/p3phelp -SkipHeaders -SkipContent
```

g.co is CN=*.google.com from CN=WR2, O=Google Trust Services, C=US
Valid 05/12/2025 01:42:58 to 08/04/2025 01:42:57
GET https://g.co/p3phelp
HTTP/1.1 302 Found
Following redirect to https://support.google.com/accounts/answer/151657?hl=en
support.google.com is CN=*.google.com from CN=WR2, O=Google Trust Services, C=US
Valid 05/12/2025 01:42:58 to 08/04/2025 01:42:57
GET https://support.google.com/accounts/answer/151657?hl=en
HTTP/1.1 301 MovedPermanently
Following redirect to https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638845176026805186-2907418293&rd=1
GET https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638845176026805186-2907418293&rd=1
HTTP/1.1 301 MovedPermanently
Following redirect to https://support.google.com/accounts/?hl=en&visit_id=638845176026805186-2907418293&rd=2&topic=3382252
GET https://support.google.com/accounts/?hl=en&visit_id=638845176026805186-2907418293&rd=2&topic=3382252
HTTP/1.1 200 OK

## PARAMETERS

### -Uri
The URL to retrieve.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: Url, Href, Src

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Method
The HTTP method verb to use.

```yaml
Type: HttpMethod
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogFile
A file to log the request to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipHeaders
Indicates headers shouldn't be output.

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

### -SkipContent
Indicates content shouldn't be output.

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

### System.Uri to retrieve.
## OUTPUTS

## NOTES
TODO: Add support for other Invoke-WebRequest parameters.

## RELATED LINKS

[Import-CharConstants.ps1]()

[Write-Info.ps1]()

[Import-Variables.ps1]()

