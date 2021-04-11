---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Trace-GitRepoTest.ps1

## SYNOPSIS
Uses git bisect to search for the point in the repo history that the test script starts returning true.

## SYNTAX

```
Trace-GitRepoTest.ps1 [-TestScript] <ScriptBlock> [[-GoodCommit] <String>] [[-BadCommit] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Trace-GitRepoTest.ps1 { dotnet build; !$? }
```

Searches the full repo history for the point at which the build broke.

## PARAMETERS

### -TestScript
A script block that returns a boolean corresponding to a state introduced at some point in the repo history.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GoodCommit
A commit from the repo history without the new state.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $(Get-GitFirstCommit.ps1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -BadCommit
A commit from the repo history with the new state.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: $(git rev-parse HEAD)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
