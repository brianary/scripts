---
external help file: -help.xml
Module Name:
online version: True
schema: 2.0.0
---

# Get-ConsoleHistory.ps1

## SYNOPSIS
Returns the DOSKey-style console command history (up arrow or F8).

## SYNTAX

```
Get-ConsoleHistory.ps1 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ConsoleHistory.ps1 |where CommandLine -like *readme*
```

Id CommandLine
-- -----------
30 gc .\README.md
56 gc .\README.md

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSObject with these properties:
### * Id: The position of the command in the console history.
### * CommandLine: The command entered in the history.
## NOTES

## RELATED LINKS
