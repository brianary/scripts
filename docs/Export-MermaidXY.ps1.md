---
external help file: -help.xml
Module Name:
online version: https://mermaid.js.org/syntax/xyChart.html
schema: 2.0.0
---

# Export-MermaidXY.ps1

## SYNOPSIS
Generates a Mermaid XY bar/line chart for the values of a series of properties.

## SYNTAX

```
Export-MermaidXY.ps1 [[-LabelProperty] <String>] [[-LineProperty] <String[]>] [[-BarProperty] <String[]>]
 [[-Title] <String>] [[-XAxisLabel] <String>] [[-YAxisLabel] <String>] [[-InputObject] <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-Item Save-*.ps1 |Export-MermaidXY.ps1 -Title "Save scripts" -Units bytes -LabelProperty Name -BarProperty Length
```

xychart-beta
title "Save scripts"
x-axis "" \[Save-PodcastEpisodes.ps1, Save-Secret.ps1, Save-WebRequest.ps1\]
y-axis "bytes" 0 --\> 3239
bar "Length" \[2754, 3239, 3112\]

## PARAMETERS

### -LabelProperty
The property to use as labels on the X axis.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LineProperty
Properties to use to render a line graph.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -BarProperty
Properties to use to render a bar graph.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
A title for the chart.

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

### -XAxisLabel
The label for the X axis.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Domain, Progression

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -YAxisLabel
The label for the Y axis.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Range, Units

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
The objects with the specified properties.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByValue)
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

### System.Object with the properties requested.
## OUTPUTS

### System.String containing Mermaid XY chart data.
## NOTES

## RELATED LINKS

[https://mermaid.js.org/syntax/xyChart.html](https://mermaid.js.org/syntax/xyChart.html)

