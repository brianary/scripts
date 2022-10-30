---
external help file: -help.xml
Module Name:
online version: https://chocolatey.org/
schema: 2.0.0
---

# Read-ChocolateySummary.ps1

## SYNOPSIS
Retrieves the a summary from the Chocolatey log.

## SYNTAX

```
Read-ChocolateySummary.ps1 [[-Position] <Int32>] [[-Level] <SourceLevels>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Read-ChocolateySummary.ps1 |Format-Table -AutoSize -Wrap
```

LogTime               Level Text
   -------               ----- ----
   2020-01-31 13:07:00 Warning You have dotnetcore-sdk v3.1.100 installed.
Version 3.1.101 is available based on your source(s).
   2020-01-31 13:08:03   Error dotnetcore-sdk not upgraded.
An error occurred during installation:
                                Already referencing a newer version of 'KB2999226'.
   2020-01-31 13:08:03   Error The upgrade of dotnetcore-sdk was NOT successful.
   2020-01-31 13:08:03   Error dotnetcore-sdk not upgraded.
An error occurred during installation:
                                Already referencing a newer version of 'KB2999226'.
   2020-01-31 13:08:08 Warning You have dropbox v88.4.172 installed.
Version 89.4.278 is available based on your source(s).
   2020-01-31 13:08:17 Warning You have Firefox v72.0.1 installed.
Version 72.0.2 is available based on your source(s).
   2020-01-31 13:08:24 Warning You have git v2.24.1.2 installed.
Version 2.25.0 is available based on your source(s).
   2020-01-31 13:12:22 Warning You have GoogleChrome v79.0.3945.117 installed.
Version 79.0.3945.130 is available based on your source(s).
   2020-01-31 13:12:37 Warning You have microsoft-windows-terminal v0.7.3451.0 installed.
Version 0.8.10261.0 is available based on your source(s).
   2020-01-31 13:12:43   Error microsoft-windows-terminal not upgraded.
An error occurred during installation:
                                Already referencing a newer version of 'KB2999226'.
   2020-01-31 13:12:43   Error The upgrade of microsoft-windows-terminal was NOT successful.
   2020-01-31 13:12:43   Error microsoft-windows-terminal not upgraded.
An error occurred during installation:
                                Already referencing a newer version of 'KB2999226'.
   2020-01-31 13:12:49 Warning You have powershell-core v6.2.3 installed.
Version 6.2.4 is available based on your source(s).
   2020-01-31 13:12:59 Warning If you started this package under PowerShell core, replacing an in-use version may be unpredictable, require multiple attempts or
                               produce errors.
   2020-01-31 13:16:04 Warning Environment Vars (like PATH) have changed.
Close/reopen your shell to
                                see the changes (or in powershell/cmd.exe just type \`refreshenv\`).
   2020-01-31 13:16:05 Warning You have slack v4.3.0 installed.
Version 4.3.2 is available based on your source(s).
   2020-01-31 13:17:41 Warning You have thunderbird v68.4.1 installed.
Version 68.4.2 is available based on your source(s).
   2020-01-31 13:18:58 Warning Chocolatey upgraded 9/64 packages.
2 packages failed.
                                See the log for details (C:\ProgramData\chocolatey\logs\chocolatey.log).
   2020-01-31 13:18:58   Error Failures
   2020-01-31 13:18:58   Error - dotnetcore-sdk (exited 1) - dotnetcore-sdk not upgraded.
An error occurred during installation:
                                Already referencing a newer version of 'KB2999226'.
   2020-01-31 13:18:58   Error - microsoft-windows-terminal (exited 1) - microsoft-windows-terminal not upgraded.
An error occurred during installation:
                                Already referencing a newer version of 'KB2999226'.

## PARAMETERS

### -Position
Indicates which Chocolatey run in the log to check.
Use negative numbers to count from the end of the log.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Level
The lowest level of importance to include.

	* All, ActivityTracing, and Verbose include everything.
	* Information includes that level, plus Warning and Error.
	* Warning includes that level, plus Error.
	* Error only includes that level.
	* Critical and Off will exclude everything, since those levels aren't used.

```yaml
Type: SourceLevels
Parameter Sets: (All)
Aliases: Verbosity
Accepted values: Off, Critical, Error, Warning, Information, Verbose, ActivityTracing, All

Required: False
Position: 2
Default value: Warning
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Management.Automation.PSCustomObject with LogTime, Level, and Text of the last
### Chocolatey log entries.
## NOTES

## RELATED LINKS

[https://chocolatey.org/](https://chocolatey.org/)

[Import-Variables.ps1]()

