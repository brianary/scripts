---
external help file: -help.xml
Module Name:
online version: https://docs.microsoft.com/powershell/module/psscriptanalyzer/invoke-scriptanalyzer
schema: 2.0.0
---

# Repair-ScriptStyle.ps1

## SYNOPSIS
Accepts justifications for script analysis rule violations, fixing the rest using Invoke-ScriptAnalysis.

## SYNTAX

```
Repair-ScriptStyle.ps1 [-Path] <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Repair-ScriptStyle.ps1 .\Repair-ScriptStyle.ps1
```

PSAvoidUsingWriteHost in A:\Scripts\Repair-ScriptStyle.ps1
 (!) Warning
 Lines: 19, 24, 25, 26, 27, 31, 32
 File 'Repair-ScriptStyle.ps1' uses Write-Host.
Avoid using Write-Host because it might not work in all hosts,
does not work when there is no host, and (prior to PS 5.0) cannot be suppressed, captured, or redirected.
Instead, use Write-Output, Write-Verbose, or Write-Information.

Confirm
Are you sure you want to perform this action?
Performing the operation "provide justification" on target "PSAvoidUsingWriteHost in A:\Scripts\Repair-ScriptStyle.ps1".
\[Y\] Yes  \[A\] Yes to All  \[N\] No  \[L\] No to All  \[S\] Suspend  \[?\] Help (default is "Y"):

## PARAMETERS

### -Path
The path to a PowerShell script file to repair the style of.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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

[https://docs.microsoft.com/powershell/module/psscriptanalyzer/invoke-scriptanalyzer](https://docs.microsoft.com/powershell/module/psscriptanalyzer/invoke-scriptanalyzer)

