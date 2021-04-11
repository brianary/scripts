---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-GitFileMetadata.ps1

## SYNOPSIS
Returns the creation and last modification metadata for a file in a git repo.

## SYNTAX

```
Get-GitFileMetadata.ps1 [-Path] <String[]> [-Recurse] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-GitFileMetadata.ps1 README.md
```

Path         : .\README.md
CreateCommit : 1fde7af
CreateAuthor : Brian Lalonde
CreateEmail  : brianary@example.com
CreateDate   : 01/19/2015 11:44:15
LastCommit   : dbe27ba
LastAuthor   : Brian Lalonde
LastEmail    : brianary@example.com
LastDate     : 12/07/2020 20:17:15

## PARAMETERS

### -Path
The path (or paths) to get metadata for.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Recurse
Recurse into subdirectories.

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

### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS

[Use-Command.ps1]()

[Get-ChildItem]()

[Resolve-Path]()

