---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Select-Html.ps1

## SYNOPSIS
Returns content from the HTML retrieved from a URL.

## SYNTAX

### TagName (Default)
```
Select-Html.ps1 [-Uri] <Uri> [[-TagName] <String>] [[-Index] <Int32>] [-IgnoreScript] [<CommonParameters>]
```

### ClassName
```
Select-Html.ps1 [-Uri] <Uri> -ClassName <String> [[-Index] <Int32>] [-IgnoreScript] [<CommonParameters>]
```

### ElementId
```
Select-Html.ps1 [-Uri] <Uri> -ElementId <String> [-IgnoreScript] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Select-Html.ps1 https://www.h2g2.com/ title
```

h2g2 - The Guide to Life, The Universe and Everything

### EXAMPLE 2
```
Select-Html.ps1 https://www.irs.gov/e-file-providers/foreign-country-code-listing-for-modernized-e-file
```

CountryName CountryCode
----------- -----------
Afghanistan AF
Akrotiri    AX
Albania     AL
...

### EXAMPLE 3
```
Select-Html.ps1 https://www.federalreserve.gov/aboutthefed/k8.htm -IgnoreScript |Format-Table -AutoSize
```

Column_0                             2021         2022          2023         2024        2025
--------                             ----         ----          ----         ----        ----
New Year's Day                       January 1    January 1*    January 1**  January 1   January 1
Birthday of Martin Luther King, Jr. 
January 18   January 17    January 16   January 15  January 20
Washington's Birthday                February 15  February 21   February 20  February 19 February 17
Memorial Day                         May 31       May 30        May 29       May 27      May 26
Juneteenth National Independence Day June 19*     June 19**     June 19      June 19     June 19
Independence Day                     July 4**     July 4        July 4       July 4      July 4
Labor Day                            September 6  September 5   September 4  September 2 September 1
Columbus Day                         October 11   October 10    October 9    October 14  October 13
Veterans Day                         November 11  November 11   November 11* November 11 November 11
Thanksgiving Day                     November 25  November 24   November 23  November 28 November 27
Christmas Day                        December 25* December 25** December 25  December 25 December 25

## PARAMETERS

### -Uri
The URL to read the HTML from.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TagName
The name of elements to return all occurrences of.

```yaml
Type: String
Parameter Sets: TagName
Aliases:

Required: False
Position: 2
Default value: Table
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClassName
The class of elements to return all occurrences of.

```yaml
Type: String
Parameter Sets: ClassName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ElementId
The ID of elements to return all occurrences of.

```yaml
Type: String
Parameter Sets: ElementId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Index
The position of an individual element to select, or all matching elements by default.

```yaml
Type: Int32
Parameter Sets: TagName, ClassName
Aliases: Position, Number

Required: False
Position: 3
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreScript
Removes \<script\> elements that can cause parsing issues.

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

[Invoke-WebRequest]()

