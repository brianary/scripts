---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Import-ClipboardTsv.ps1

## SYNOPSIS
Parses TSV clipboard data into objects.

## SYNTAX

```
Import-ClipboardTsv.ps1 [[-Delimeter] <Char>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Import-ClipboardTsv.ps1 |Format-Table -AutoSize
```

Name              Alias        Actor
----              -----        -----
Rita Farr         Elasti-Girl  April Bowlby
Larry Trainor     Negative Man Matt Bomer/Mathew Zuk
Kay Challis       Crazy Jane   Diane Guerrero
Cliff Steele      Robotman     Brendan Fraser/Riley Shanahan
Victor Stone      Cyborg       Joivan Wade
Dr.
Niles Caulder The Chief    Timothy Dalton
Eric Morden       Mr.
Nobody   Alan Tudyk

## PARAMETERS

### -Delimeter
{{ Fill Delimeter Description }}

```yaml
Type: Char
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[Get-Clipboard]()

[ConvertFrom-Csv]()

