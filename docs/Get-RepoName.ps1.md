---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-RepoName.ps1

## SYNOPSIS
Gets the name of the repo.

## SYNTAX

```
Get-RepoName.ps1 [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-RepoName.ps1
```

## PARAMETERS

### -Path
The path to the git repo to get the name for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: False
Position: 1
Default value: $PWD.Path
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Objects with System.String Path or FullName properties.
## OUTPUTS

### System.String of the repo name (the final segment of the first remote location).
## NOTES

## RELATED LINKS
