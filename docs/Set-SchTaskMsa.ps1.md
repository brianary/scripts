---
external help file: -help.xml
Module Name:
online version: https://learn.microsoft.com/windows-server/identity/ad-ds/manage/group-managed-service-accounts/group-managed-service-accounts/group-managed-service-accounts-overview
schema: 2.0.0
---

# Set-SchTaskMsa.ps1

## SYNOPSIS
Sets a Scheduled Task's runtime user as the given gMSA/MSA.

## SYNTAX

```
Set-SchTaskMsa.ps1 [-TaskName] <String> [-ServiceAccount] <String> [-HighestRunLevel]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Set-SchTaskMsa.ps1 'Backup VSCode settings' automation
```

Sets the tasks running user to the "automation" managed service account.

## PARAMETERS

### -TaskName
{{ Fill TaskName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ServiceAccount
{{ Fill ServiceAccount Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: MSA, gMSA, UserId

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HighestRunLevel
{{ Fill HighestRunLevel Description }}

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

### An object with a TaskName string property.
## OUTPUTS

## NOTES

## RELATED LINKS

[https://learn.microsoft.com/windows-server/identity/ad-ds/manage/group-managed-service-accounts/group-managed-service-accounts/group-managed-service-accounts-overview](https://learn.microsoft.com/windows-server/identity/ad-ds/manage/group-managed-service-accounts/group-managed-service-accounts/group-managed-service-accounts-overview)

[Set-ScheduledTask]()

[New-ScheduledTaskPrincipal]()

