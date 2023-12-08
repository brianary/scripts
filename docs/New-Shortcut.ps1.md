---
external help file: -help.xml
Module Name:
online version: https://ss64.com/vb/shortcut.html
schema: 2.0.0
---

# New-Shortcut.ps1

## SYNOPSIS
Create a Windows shortcut.

## SYNTAX

```
New-Shortcut.ps1 [-Path] <String> [-TargetPath] <String> [[-Arguments] <String>] [[-WorkingDirectory] <String>]
 [-Description <String>] [-Hotkey <String>] [-IconLocation <String>] [-WindowStyle <String>]
 [-RunAsAdministrator] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-Shortcut -Path "$Home\Desktop\Explorer.lnk" -TargetPath '%SystemRoot%\explorer.exe' -RunAsAdministrator
```

Creates an Explorer shortcut on the desktop that runs as admin.

## PARAMETERS

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TargetPath
The path of the file the shortcut will point to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Arguments
Any command-line parameters to pass to the TargetPath, if it is a program.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkingDirectory
The folder to run TargetPath in.

```yaml
Type: String
Parameter Sets: (All)
Aliases: StartIn

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Some descriptive text for the shortcut.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Comment

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hotkey
A Windows Explorer key combination to open the shortcut, usually starting with
"Ctrl + Alt +".

```yaml
Type: String
Parameter Sets: (All)
Aliases: ShortcutKey

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IconLocation
The path to a file with an icon to use, and an index, e.g.

	%SystemRoot%\system32\SHELL32.dll,244

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

### -WindowStyle
The state the window should start in: Normal, Maximized, or Minimized.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Run

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunAsAdministrator
Indicates the shortcut should invoke UAC and run as an admin.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Admin

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

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[https://ss64.com/vb/shortcut.html](https://ss64.com/vb/shortcut.html)

