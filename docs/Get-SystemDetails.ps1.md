---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Get-SystemDetails.ps1

## SYNOPSIS
Collects some useful system hardware and operating system details via WMI.

## SYNTAX

```
Get-SystemDetails.ps1 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-SystemDetails.ps1
```

Name             : DEEPTHOUGHT
Status           : OK
Manufacturer     : Microsoft Corporation
Model            : Surface Pro 4
PrimaryOwnerName :
Memory           : 3.93 GiB (25.68 % free)
OperatingSystem  : Microsoft Windows 10 Pro64-bit  (10.0.14393)
Processors       : Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz
Drives           : C: 118 GiB (31.47 % free)
Shares           :
NetVersions      : {v4.6.2+win10ann, v3.5, v2.0.50727, v3.0}

## PARAMETERS

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

### System.Management.Automation.PSCustomObject with properties about the computer:
### * Name: The computer name.
### * Status: The reported computer status name.
### * Manufacturer: The reported computer manufacturer name.
### * Model: The reported computer model name.
### * PrimaryOwnerName: The reported name of the owner of the computer, if available.
### * Memory: The reported memory in the computer, and amount unused.
### * OperatingSystem: The name and type of operating system used by the computer.
### * Processors: CPU hardware detais.
### * Drives: Storage drives found on the computer.
### * Shares: The file shares configured, if any.
### * NetVersions: The versions of .NET on the system.
## NOTES

## RELATED LINKS
