---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Format-HtmlDataTable.ps1

## SYNOPSIS
Right-aligns numeric data in an HTML table for emailing, and optionally zebra-stripes &c.

## SYNTAX

```
Format-HtmlDataTable.ps1 [[-Caption] <String>] [[-OddRowBackground] <String>] [[-EvenRowBackground] <String>]
 [-TableAttributes <String>] [-CaptionAttributes <String>] [-NumericFormat <String>] [-Html <String>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Invoke-Sqlcmd "..." |ConvertFrom-DataRow.ps1 |ConvertTo-Html |Format-HtmlDataTable.ps1
```

Runs the query, parses each row into an HTML row, then fixes the alignment of numeric cells.

### EXAMPLE 2
```
$rows |ConvertTo-Html -Fragment |Format-HtmlDataTable.ps1 'Products' '#F99' '#FFF'
```

Renders DataRows as an HTML table, right-aligns numeric cells, then adds a caption ("Products"),
and alternates the rows between pale yellow and white.

## PARAMETERS

### -Caption
{{ Fill Caption Description }}

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

### -OddRowBackground
The background CSS value for odd rows.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EvenRowBackground
The background CSS value for even rows.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TableAttributes
Any table attributes desired (cellpadding, cellspacing, style, &c.).

```yaml
Type: String
Parameter Sets: (All)
Aliases: TableAtts

Required: False
Position: Named
Default value: Cellpadding="2" cellspacing="0" style="font:x-small 'Lucida Console',monospace"
Accept pipeline input: False
Accept wildcard characters: False
```

### -CaptionAttributes
{{ Fill CaptionAttributes Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: CaptionAtts, CapAtts

Required: False
Position: Named
Default value: Style="font:bold small serif;border:1px inset #DDD;padding:1ex 0;background:#FFF"
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumericFormat
Applies a standard .NET formatting pattern to numbers, such as N or '#,##0.000;(#,##0.000);zero'.

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

### -Html
The HTML table data to be piped in.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String containing an HTML table, as produced by ConvertTo-Html.
## OUTPUTS

### System.String containing the data-formatted HTML table.
## NOTES
Assumes only one \<tr\> element per string piped in, as produced by ConvertTo-Html.

## RELATED LINKS

[ConvertTo-Html]()

[https://www.w3.org/Bugs/Public/show_bug.cgi?id=18026](https://www.w3.org/Bugs/Public/show_bug.cgi?id=18026)

