---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Use-Command.ps1

## SYNOPSIS
Checks for the existence of the given command, and adds if missing and a source is defined.

## SYNTAX

### WindowsFeature
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-WindowsFeature <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ChocolateyPackage
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-ChocolateyPackage <String>] [-Version <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### DotNetTool
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-DotNetTool <String>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### NugetPackage
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-NugetPackage <String>] [-Version <String>]
 [-InstallDir <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### NodePackage
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-NodePackage <String>] [-Version <String>]
 [-InstallDir <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### WindowsInstaller
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-WindowsInstaller <Uri>] [-InstallLevel <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ExecutableInstaller
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-ExecutableInstaller <Uri>]
 [-InstallerParameters <String[]>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ExecutePS
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-ExecutePowerShell <Uri>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### DownloadZip
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-DownloadZip <Uri>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### DownloadUrl
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-DownloadUrl <Uri>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### WarnOnly
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-Message <String>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Fail
```
Use-Command.ps1 [-Name] <String> [-Path] <String> [-Fail] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Use-Command checks to see if a command exists by the name given.

If the command does not exist, but the path is valid, an alias is created.

Otherwise, if one of several installation methods is provided, an installation attempt is made before aliasing.

## EXAMPLES

### EXAMPLE 1
```
Use-Command.ps1 nuget $ToolsDir\NuGet\nuget.exe -url https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
```

This example downloads and aliases nuget, if missing.

### EXAMPLE 2
```
Use-Command.ps1 npm 'C:\Program Files\nodejs\npm.cmd' -cinst nodejs
```

This example downloads and silently installs node if npm is missing.

### EXAMPLE 3
```
Use-Command.ps1 Get-ADUser $null -WindowsFeature RSAT-AD-PowerShell
```

This example downloads and installs the RSAT-AD-PowerShell module if missing.

## PARAMETERS

### -Name
The name of the command to test.

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

### -Path
The full path of the command, if installed.
Accepts wildcards, as supported by Resolve-Path.

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

### -WindowsFeature
{{ Fill WindowsFeature Description }}

```yaml
Type: String
Parameter Sets: WindowsFeature
Aliases: WinFeature

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChocolateyPackage
The name of the Chocolatey package to install if the command is missing.

```yaml
Type: String
Parameter Sets: ChocolateyPackage
Aliases: ChocoPackage, chocopkg, cinst

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DotNetTool
The name of the .NET global tool to install if the command is missing.

```yaml
Type: String
Parameter Sets: DotNetTool
Aliases: DotNetGlobalTool, dotnet

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NugetPackage
The name of the NuGet package to install if the command is missing.

```yaml
Type: String
Parameter Sets: NugetPackage
Aliases: nupkg

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NodePackage
The name of the Node NPM package to install if the command is missing.

```yaml
Type: String
Parameter Sets: NodePackage
Aliases: npm

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
The specific package version to install.

```yaml
Type: String
Parameter Sets: ChocolateyPackage, NugetPackage, NodePackage
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallDir
The directory to install NuGet or Node packages to.
Node will create and use a "node_modules" folder under this one.
Default is C:\Tools

```yaml
Type: String
Parameter Sets: NugetPackage, NodePackage
Aliases: dir

Required: False
Position: Named
Default value: C:\Tools
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsInstaller
The location (file or URL) of an MSI package to install if the command is missing.

```yaml
Type: Uri
Parameter Sets: WindowsInstaller
Aliases: msi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallLevel
The INSTALLLEVEL to pass to Windows Installer.
Default is 32767

```yaml
Type: Int32
Parameter Sets: WindowsInstaller
Aliases:

Required: False
Position: Named
Default value: 32767
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExecutableInstaller
The location (file or URL) of an .exe installer to use if the command is missing.

```yaml
Type: Uri
Parameter Sets: ExecutableInstaller
Aliases: exe

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstallerParameters
Parameters to pass to the .exe installer.

```yaml
Type: String[]
Parameter Sets: ExecutableInstaller
Aliases: params

Required: False
Position: Named
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExecutePowerShell
The URL or file path of a PowerShell script to download and execute to install the command if it is missing.

```yaml
Type: Uri
Parameter Sets: ExecutePS
Aliases: iex

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DownloadZip
The URL to download a .zip file containing the command if it is missing.

```yaml
Type: Uri
Parameter Sets: DownloadZip
Aliases: zip

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DownloadUrl
The URL to download the command from if it is missing.

```yaml
Type: Uri
Parameter Sets: DownloadUrl
Aliases: url

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
A message to display, rather than attempting to install a missing command.

```yaml
Type: String
Parameter Sets: WarnOnly
Aliases: msg

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fail
Throw an exception rather than attempt to install a missing command.

```yaml
Type: SwitchParameter
Parameter Sets: Fail
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

## OUTPUTS

### System.Void
## NOTES

## RELATED LINKS

[Find-NewestFile.ps1]()

[Resolve-Path]()

[https://chocolatey.org/](https://chocolatey.org/)

[https://www.nuget.org/](https://www.nuget.org/)

[https://www.npmjs.com/](https://www.npmjs.com/)

[https://technet.microsoft.com/library/bb490936.aspx](https://technet.microsoft.com/library/bb490936.aspx)

[http://www.iheartpowershell.com/2013/05/powershell-supportsshouldprocess-worst.html](http://www.iheartpowershell.com/2013/05/powershell-supportsshouldprocess-worst.html)

