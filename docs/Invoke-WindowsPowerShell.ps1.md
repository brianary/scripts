---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Invoke-WindowsPowerShell.ps1

## SYNOPSIS
Runs commands in Windows PowerShell (typically from PowerShell Core).

## SYNTAX

### CommandBlock
```
Invoke-WindowsPowerShell.ps1 [-CommandBlock] <ScriptBlock> [[-BlockArgs] <PSObject[]>] [<CommonParameters>]
```

### CommandText
```
Invoke-WindowsPowerShell.ps1 [-CommandText] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Invoke-WindowsPowerShell.ps1 '$PSVersionTable.PSEdition'
```

Desktop

### EXAMPLE 2
```
Invoke-WindowsPowerShell.ps1 {Param($n); Get-WmiObject Win32_Process -Filter "Name like '$n'" |foreach ProcessName} power%
```

PowerToys.exe
PowerToys.Awake.exe
PowerToys.FancyZones.exe
PowerToys.KeyboardManagerEngine.exe
PowerLauncher.exe
powershell.exe
powershell.exe

## PARAMETERS

### -CommandBlock
A script block to run.

```yaml
Type: ScriptBlock
Parameter Sets: CommandBlock
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BlockArgs
Parameters to the script block.

```yaml
Type: PSObject[]
Parameter Sets: CommandBlock
Aliases:

Required: False
Position: 2
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandText
The text of the command to run.

```yaml
Type: String
Parameter Sets: CommandText
Aliases:

Required: True
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

[Use-Command.ps1]()

[ConvertTo-Base64.ps1]()

[Stop-ThrowError.ps1]()

