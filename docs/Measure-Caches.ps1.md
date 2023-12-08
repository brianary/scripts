---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Measure-Caches.ps1

## SYNOPSIS
Returns a list of matching cache directories, and their sizes, sorted.

## SYNTAX

```
Measure-Caches.ps1 [[-Path] <String>] [[-NamePattern] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Measure-Caches.ps1 |Format-Table -AutoSize
```

Path                                                                Size    DirectorySize DirectorySizeOnDisk
----                                                                ----    ------------- -------------------
c:\users\usernam\appdata\roaming\code\cachedextensionvsixs          669.3MB     701856767           701915136
c:\users\usernam\appdata\roaming\slack\service worker\cachestorage  444MB       465538811           469655552
c:\users\usernam\appdata\roaming\slack\cache                        340.2MB     356697780           357654528
c:\users\usernam\appdata\roaming\slack\cache\cache_data             340.2MB     356697780           357650432
c:\users\usernam\appdata\roaming\code\cache\cache_data              323.3MB     338983271           339546112
c:\users\usernam\appdata\roaming\code\cache                         323.3MB     338983271           339550208
c:\users\usernam\appdata\roaming\slack\code cache                   282MB       295745766           301752320
c:\users\usernam\appdata\roaming\code\cacheddata                    172.6MB     181008350           191647744

## PARAMETERS

### -Path
The root directory to search from.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $env:APPDATA
Accept pipeline input: False
Accept wildcard characters: False
```

### -NamePattern
The directory name pattern to match using -Like.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *cache*
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
A shocking number of apps don't seem to know how the Windows folder structure
works, writing cache data into the user profile's Roaming folder, which gets
recopied at every logon, which is extremely wrong.

This script is primarily intended to show the scope of the problem, but can
be used to measure other folder matches.

## RELATED LINKS

[Use-Command.ps1]()

[Format-ByteUnits.ps1]()

