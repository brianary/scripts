---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Test-HttpSecurity.ps1

## SYNOPSIS
Scan sites using Mozilla's Observatory.

## SYNTAX

```
Test-HttpSecurity.ps1 [-Hosts] <String[]> [-Force] [-Public] [-IncludeResults] [-PollingInterval <Int32>]
 [-Endpoint <Uri>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Test-HttpSecurity.ps1 www.example.net -Public
```

end_time             : Thu, 22 Dec 2016 00:09:31 GMT
grade                : F
hidden               : False
likelihood_indicator : MEDIUM
response_headers     : @{Accept-Ranges=bytes; Cache-Control=max-age=604800; Content-Encoding=gzip; 
                       Content-Length=606; Content-Type=text/html; Date=Thu, 22 Dec 2016 00:09:31 GMT; 
                       Etag="359670651+gzip"; Expires=Thu, 29 Dec 2016 00:09:31 GMT; Last-Modified=Fri, 09 Aug 
                       2013 23:54:35 GMT; Server=ECS (sjc/4E3B); Vary=Accept-Encoding; X-Cache=HIT; 
                       x-ec-custom-error=1}
scan_id              : 2899791
score                : 0
start_time           : Thu, 22 Dec 2016 00:09:29 GMT
state                : FINISHED
tests_failed         : 6
tests_passed         : 6
tests_quantity       : 12
results              : https://http-observatory.security.mozilla.org/api/v1/getScanResults?scan=2899791
host                 : www.example.net

### EXAMPLE 2
```
Test-HttpSecurity.ps1 www.example.com -IncludeResults
```

end_time             : Thu, 22 Dec 2016 16:17:17 GMT
grade                : F
hidden               : True
likelihood_indicator : MEDIUM
response_headers     : @{Accept-Ranges=bytes; Cache-Control=max-age=604800; Content-Encoding=gzip; 
                       Content-Length=606; Content-Type=text/html; Date=Thu, 22 Dec 2016 16:17:17 GMT; 
                       Etag="359670651+gzip"; Expires=Thu, 29 Dec 2016 16:17:17 GMT; Last-Modified=Fri, 09 Aug 
                       2013 23:54:35 GMT; Server=ECS (sjc/4E5C); Vary=Accept-Encoding; X-Cache=HIT; 
                       x-ec-custom-error=1}
scan_id              : 2903851
score                : 0
start_time           : Thu, 22 Dec 2016 16:17:16 GMT
state                : FINISHED
tests_failed         : 6
tests_passed         : 6
tests_quantity       : 12
results              : @{content-security-policy=; contribute=; cookies=; cross-origin-resource-sharing=; 
                       public-key-pinning=; redirection=; referrer-policy=; strict-transport-security=; 
                       subresource-integrity=; x-content-type-options=; x-frame-options=; x-xss-protection=}
host                 : www.example.com

## PARAMETERS

### -Hosts
Hostnames to scan, e.g.
www.example.org

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Force
Indicates a new scan should be performed, rather than returning a cached one.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Rescan

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Public
Indicates the scan results may be posted publically.
By default, scans are unlisted.

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

### -IncludeResults
Indicates the detailed scan results should be fetched rather than simply providing a URL for them.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Details, Results, FetchResults

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PollingInterval
The number of milliseconds to wait between polling the hostnames for scan completion.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1753
Accept pipeline input: False
Accept wildcard characters: False
```

### -Endpoint
The address of the Observatory web service.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Https://http-observatory.security.mozilla.org/api/v1
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

### System.String containing a URL host to check.
## OUTPUTS

### System.Management.Automation.PSObject containing scan results.
## NOTES

## RELATED LINKS

[Invoke-RestMethod]()

[https://observatory.mozilla.org/](https://observatory.mozilla.org/)

