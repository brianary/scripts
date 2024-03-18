---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Find-DotNetTools.ps1

## SYNOPSIS
Returns a list of matching dotnet tools.

## SYNTAX

```
Find-DotNetTools.ps1 [-Name] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Find-DotNetTools.ps1 interactive |Format-Table -AutoSize
```

PackageName                  Version     Authors                Downloads Verified
-----------                  -------     -------                --------- --------
microsoft.dotnet-interactive 1.0.516401  Microsoft              33682741      True
dotnet-repl                  0.1.216     jonsequitur            117599       False

## PARAMETERS

### -Name
The name of the tool to search for.

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

## OUTPUTS

## NOTES

## RELATED LINKS
