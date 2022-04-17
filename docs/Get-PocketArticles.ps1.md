---
external help file: -help.xml
Module Name:
online version: https://getpocket.com/developer/
schema: 2.0.0
---

# Get-PocketArticles.ps1

## SYNOPSIS
Retrieves a list of saved articles from a Pocket account.

## SYNTAX

```
Get-PocketArticles.ps1 [-After] <DateTime> [-Before] <DateTime> [[-Search] <String>] [-Domain <String>]
 [-State <String>] [-Tag <String>] [-Sort <String>] [-ContentType <String>] [-Vault <String>] [-Favorite]
 [-Detailed] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Export-PocketArticles.ps1 2020-02-15 2021-03-01 -State Archive -Tag Programming -Sort Newest |Format-Table -Auto
```

item_id    resolved_id given_url                                                                             given_title                                                                 favorite status time_added time_updated time_read  time_favorited
-------    ----------- ---------                                                                             -----------                                                                 -------- ------ ---------- ------------ ---------  --------------
2713538930 2713538930  https://dev.to/thementor/i-run-powershell-on-android-and-so-can-you-458k              I run PowerShell on Android and so can you !!
- DEV Community               1        1      1610230461 1610432554   1610430179 1610432553
3002666222 3002666222  https://www.theregister.com/2020/06/01/linux_5_7/                                     80-characters-per-line limits should be terminal, says Linux kernel chief L 0        1      1609706654 1609781229   1609781227 0
3195903579 3195903579  https://devblogs.microsoft.com/powershell/announcing-powershell-crescendo-preview-1/  Announcing PowerShell Crescendo Preview.1 | PowerShell                      0        1      1607526051 1608436421   1608436415 0
3044493651 3044493651  https://www.compositional-it.com/news-blog/5-features-that-c-has-that-f-doesnt-have/  5 Features C# Has That F# Doesn't Have!
| Compositional IT                  0        1      1594439301 1594500813   1594500812 0
2908050151 2908050151  https://thesharperdev.com/examples-using-httpclient-in-fsharp/                        Examples Using HttpClient in F# - The Sharper Dev                           0        1      1583616769 1583616987   1583616986 0
2907176185 2907176185  https://voiceofthedba.com/2020/03/06/the-developer-arguments-for-stored-procedures/   The Developer Arguments for Stored Procedures                               0        1      1583519345 1583616940   1583616940 0
2903715421 2903715421  https://khalidabuhakmeh.com/upgraded-dotnet-console-experience                        Upgrade Your .NET Console App Experience | Khalid Abuhakmeh                 0        1      1583440478 1583715611   1583715610 0
1526616723 1526616723  https://support.google.com/maps/answer/7047426? 
Find and share places using plus codes                                      0        1      1565309293 1610746653   1565642230 0

## PARAMETERS

### -After
Return articles newer than this time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Before
Return articles older than this time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Search
Return articles containing this search term.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
Return articles from this domain.

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

### -State
Return articles with this read/archived/either status.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Unread
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
Return articles with this tag.

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

### -Sort
Specifies a method for sorting returned articles.

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

### -ContentType
Return only video, image, or text articles as specified.

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

### -Vault
The name of the secret vault to retrieve the Pocket API consumer key from.
By default, the default vault is used.

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

### -Favorite
Return only favorite articles.

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

### -Detailed
Return full article details.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject containing article details.
### See https://getpocket.com/developer/docs/v3/retrieve for fields.
## NOTES
You'll need a "consumer key" (API key; see the link below to "create new app").
You'll be prompted for that, and to authorize it to your account.

## RELATED LINKS

[https://getpocket.com/developer/](https://getpocket.com/developer/)

[Set-ParameterDefault.ps1]()

[Get-CachedCredential.ps1]()

[ConvertTo-EpochTime.ps1]()

[Remove-NullValues.ps1]()

