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
Trace-WebRequest.ps1 g.co/p3phelp -SkipContent
```

📤️ GET g.co/p3phelp

📥️ HTTP/1.1 301 MovedPermanently
Cache-Control: no-store, must-revalidate, no-cache, max-age=0
Pragma: no-cache
Date: Thu, 26 Dec 2024 21:08:21 GMT
Location: https://g.co/p3phelp
Server: ESF
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Content-Type: application/binary
Expires: Mon, 01 Jan 1990 00:00:00 GMT
Content-Length: 0
ℹ️ Following redirect to https://g.co/p3phelp
📤️ GET https://g.co/p3phelp

📥️ HTTP/1.1 302 Found
Vary: Sec-Fetch-Dest
Vary: Sec-Fetch-Mode
Vary: Sec-Fetch-Site
Cache-Control: no-store, must-revalidate, no-cache, max-age=0
Pragma: no-cache
Date: Thu, 26 Dec 2024 21:08:22 GMT
Location: https://support.google.com/accounts/answer/151657?hl=en
Strict-Transport-Security: max-age=31536000
Cross-Origin-Opener-Policy: unsafe-none
Cross-Origin-Resource-Policy: same-site
Server: ESF
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
Alt-Svc: h3=":443"; ma=2592000
Alt-Svc: h3-29=":443"; ma=2592000
Content-Type: application/binary
Expires: Mon, 01 Jan 1990 00:00:00 GMT
Content-Length: 0
ℹ️ Following redirect to https://support.google.com/accounts/answer/151657?hl=en
📤️ GET https://support.google.com/accounts/answer/151657?hl=en

📥️ HTTP/1.1 301 MovedPermanently
Location: https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638708441023370154-2201542783&rd=1
X-Robots-Tag: follow,index
Date: Thu, 26 Dec 2024 21:08:22 GMT
Cache-Control: max-age=0, private
X-Content-Type-Options: nosniff
Server: support-content-ui
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
Alt-Svc: h3=":443"; ma=2592000
Alt-Svc: h3-29=":443"; ma=2592000
Expires: Thu, 26 Dec 2024 21:08:22 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 304
ℹ️ Following redirect to https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638708441023370154-2201542783&rd=1
📤️ GET https://support.google.com/accounts/topic/3382252?hl=en&visit_id=638708441023370154-2201542783&rd=1

📥️ HTTP/1.1 301 MovedPermanently
Location: https://support.google.com/accounts/?hl=en&visit_id=638708441023370154-2201542783&rd=2&topic=3382252
X-Robots-Tag: follow,noindex
Date: Thu, 26 Dec 2024 21:08:22 GMT
Cache-Control: max-age=0, private
X-Content-Type-Options: nosniff
Server: support-content-ui
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
Alt-Svc: h3=":443"; ma=2592000
Alt-Svc: h3-29=":443"; ma=2592000
Expires: Thu, 26 Dec 2024 21:08:22 GMT
Content-Type: text/html; charset=UTF-8
Content-Length: 309
ℹ️ Following redirect to https://support.google.com/accounts/?hl=en&visit_id=638708441023370154-2201542783&rd=2&topic=3382252
📤️ GET https://support.google.com/accounts/?hl=en&visit_id=638708441023370154-2201542783&rd=2&topic=3382252

📥️ HTTP/1.1 200 OK
P3P: CP="This is not a P3P policy!
See g.co/p3phelp for more info."
P3P: CP="This is not a P3P policy!
See g.co/p3phelp for more info."
P3P: CP="This is not a P3P policy!
See g.co/p3phelp for more info."
Strict-Transport-Security: max-age=31536000; includeSubdomains
Date: Thu, 26 Dec 2024 21:08:23 GMT
Cache-Control: max-age=0, private
Content-Security-Policy-Report-Only: object-src 'none';base-uri 'self';script-src 'nonce-69sNhX1vigTzFtuMUufk' 'unsafe-inline' 'unsafe-eval' 'strict-dynamic' https: http: 'report-sample';report-uri https://csp.withgoogle.com/csp/scfe
X-Content-Type-Options: nosniff
Server: support-content-ui
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
Alt-Svc: h3=":443"; ma=2592000
Alt-Svc: h3-29=":443"; ma=2592000
Transfer-Encoding: chunked
Content-Type: text/html; charset=UTF-8
Expires: Thu, 26 Dec 2024 21:08:23 GMT

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

