---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Save-Secret.ps1

## SYNOPSIS
Sets a secret in a secret vault with metadata.

## SYNTAX

### Secret
```
Save-Secret.ps1 [-Name] <String> [-Secret] <SecureString> [-Title <String>] [-Description <String>]
 [-Note <String>] [-Uri <Uri>] [-Created <DateTime>] [-Expires <DateTime>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Credential
```
Save-Secret.ps1 [-Name] <String> [-Credential] <PSCredential> [-Title <String>] [-Description <String>]
 [-Note <String>] [-Uri <Uri>] [-Created <DateTime>] [-Expires <DateTime>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Paste
```
Save-Secret.ps1 [-Name] <String> [-Title <String>] [-Description <String>] [-Note <String>] [-Uri <Uri>]
 [-Created <DateTime>] [-Expires <DateTime>] -Paste <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### PasteForUser
```
Save-Secret.ps1 [-Name] <String> [-Title <String>] [-Description <String>] [-Note <String>] [-Uri <Uri>]
 [-Created <DateTime>] [-Expires <DateTime>] -PasteForUser <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### PasteTextBytes
```
Save-Secret.ps1 [-Name] <String> [-Title <String>] [-Description <String>] [-Note <String>] [-Uri <Uri>]
 [-Created <DateTime>] [-Expires <DateTime>] -PasteTextBytes <Encoding> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Save-Secret.ps1 GitHubToken -Paste securestring -Title 'PowerShell token' -Description 'A GitHub classic token' -Url https://github.com/settings/tokens -Expires (Get-Date).AddDays(90)
```

Stores the token from the clipboard.

## PARAMETERS

### -Name
{{ Fill Name Description }}

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

### -Secret
{{ Fill Secret Description }}

```yaml
Type: SecureString
Parameter Sets: Secret
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Specifies the value of the credential to store.

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
{{ Fill Title Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
{{ Fill Description Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Note
{{ Fill Note Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Uri
{{ Fill Uri Description }}

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Created
{{ Fill Created Description }}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Expires
{{ Fill Expires Description }}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Paste
{{ Fill Paste Description }}

```yaml
Type: String
Parameter Sets: Paste
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PasteForUser
{{ Fill PasteForUser Description }}

```yaml
Type: String
Parameter Sets: PasteForUser
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PasteTextBytes
{{ Fill PasteTextBytes Description }}

```yaml
Type: Encoding
Parameter Sets: PasteTextBytes
Aliases:

Required: True
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
