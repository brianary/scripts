---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Save-PodcastEpisodes.ps1

## SYNOPSIS
Saves enclosures from a podcast feed.

## SYNTAX

```
Save-PodcastEpisodes.ps1 [-Uri] <Uri> [-After <DateTime>] [-Before <DateTime>] [-First <Int32>] [-Last <Int32>]
 [-UseTitle] [-CreateFolder] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Save-PodcastEpisodes.ps1 https://www.youlooknicetoday.com/rss -UseTitle
```

Saves podcast episodes to the current directory.

## PARAMETERS

### -Uri
The URL of the podcast feed.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases: Url

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -After
Episodes before this date will be ignored.

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

### -Before
Episodes after this date will be ignored.

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

### -First
Includes only the given number of initial episodes, by publish date.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Last
Includes only the given number of most recent episodes, by publish date.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseTitle
Use episode titles for filenames.

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

### -CreateFolder
Saves the episodes into a folder with the podcast name.

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

## OUTPUTS

## NOTES

## RELATED LINKS

[Save-WebRequest.ps1]()

