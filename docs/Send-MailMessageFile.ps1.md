---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Send-MailMessageFile.ps1

## SYNOPSIS
Sends emails from a drop folder using .NET config defaults.

## SYNTAX

```
Send-MailMessageFile.ps1 [[-MailFile] <FileInfo[]>] [-Delete] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Send-MailMessageFiles.ps1
```

Sends all .eml files in the current directory.

### EXAMPLE 2
```
ls C:\Inetpub\mailroot\*.eml |Send-MailMessageFile.ps1
```

Sends emails from drop directory.

## PARAMETERS

### -MailFile
The .eml file to parse and send.

```yaml
Type: FileInfo[]
Parameter Sets: (All)
Aliases: Eml

Required: False
Position: 1
Default value: (Get-ChildItem *.eml)
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Delete
Indicates sent files should be deleted.

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

### System.IO.FileInfo of .eml files to send.
## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[Send-MailMessage]()

[Use-NetMailConfig.ps1]()

