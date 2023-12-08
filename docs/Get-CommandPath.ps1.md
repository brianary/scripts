---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-CommandPath.ps1

## SYNOPSIS
Locates a command.

## SYNTAX

```
Get-CommandPath.ps1 [-ApplicationName] <String[]> [-FindAllInPath] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns the full path to an application found in a directory in $env:Path,
optionally with an extension from $env:PathExt.

## EXAMPLES

### EXAMPLE 1
```
Get-CommandPath.ps1 powershell
```

C:\windows\System32\WindowsPowerShell\v1.0\powershell.exe

## PARAMETERS

### -ApplicationName
The name of the executable program to look for in the $env:Path directories,
if the extension is omitted, $env:PathExt will be used to find one.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name, AN

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -FindAllInPath
Indicates that every directory in the Path should be searched for the command.

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

### System.String of commands to get the location details of.
## OUTPUTS

### System.String of location details for the specified commands that were found.
## NOTES

## RELATED LINKS

[Get-Command]()

