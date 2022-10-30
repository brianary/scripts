---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/dotnet/standard/base-types/substitutions-in-regular-expressions
schema: 2.0.0
---

# Set-RegexReplace.ps1

## SYNOPSIS
Updates text found with Select-String, using a regular expression replacement template.

## SYNTAX

```
Set-RegexReplace.ps1 [-Replacement] <String> [-InputObject <MatchInfo>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
)' README.md |Set-RegexReplace.ps1 "`$1 $(Get-Date) `$2"
```

Updates the generated date in README.md.

### EXAMPLE 2
```
\d+</td>)' |Set-RegexReplace.ps1 '$1 align="right"$2'
```

\<table\>
\<colgroup\>\<col/\>\<col/\>\</colgroup\>
\<tr\>\<th\>Name\</th\>\<th\>Length\</th\>\</tr\>
\<tr\>\<td\>README.md\</td\>\<td align="right"\>21099\</td\>\</tr\>
\</table\>

## PARAMETERS

### -Replacement
A regular expression replacement string.

* $$ is a literal $
* $_ is the entire input string.
* $\` is the string before the match.
* $& is the entire matching string.
* $' is the string after the match.
* $1 is the first matching group.
* $n (where n is a number) is the nth matching group.
* $name is the group named "name".
* $+ is the last matching group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
The output from Select-String.

```yaml
Type: MatchInfo
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

### Microsoft.PowerShell.Commands.MatchInfo containing a regex match than will be replaced.
## OUTPUTS

### System.String of the input string if the Select-String's input was a string instead of a file.
### (File changes will be saved back to the file.)
## NOTES

## RELATED LINKS

[https://docs.microsoft.com/dotnet/standard/base-types/substitutions-in-regular-expressions](https://docs.microsoft.com/dotnet/standard/base-types/substitutions-in-regular-expressions)

[Get-Encoding.ps1]()

