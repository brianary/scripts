---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Update-DotNetPackages.ps1

## SYNOPSIS
Updates NuGet packages for a .NET solution or project.

## SYNTAX

```
Update-DotNetPackages.ps1 [-Path] <String> [[-Reason] <String>] [[-SkipPackages] <String[]>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Update-DotNetPackages.ps1 src Deprecated
```

A:/AzFnRepo/src/AzFnDemo/AzFnDemo.csproj: net6.0
A:/AzFnRepo/src/AzFnDemo/AzFnDemo.csproj: Microsoft.NET.Sdk.Functions \[Deprecated\] Other Legacy
A:/AzFnRepo/src/AzFnDemo/AzFnDemo.csproj: Upgrading 'Microsoft.NET.Sdk.Functions' from 4.1.0 to 4.6.0
WARNING: A:/AzFnRepo/src/AzFnDemo/AzFnDemo.csproj: Removing 1 duplicate 'Microsoft.NET.Sdk.Functions' entries
A:/AzFnRepo/src/AzFnDemo.Tests/AzFnDemo.Tests.csproj: up to date
A:/AzFnRepo/src/AzFnDemo.Core/AzFnDemo.Core.csproj: net6.0
A:/AzFnRepo/src/AzFnDemo.Core/AzFnDemo.Core.csproj: Microsoft.NET.Sdk.Functions \[Deprecated\] Other Legacy
A:/AzFnRepo/src/AzFnDemo.Core/AzFnDemo.Core.csproj: Upgrading 'Microsoft.NET.Sdk.Functions' from 4.1.0 to 4.6.0
WARNING: A:/AzFnRepo/src/AzFnDemo.Core/AzFnDemo.Core.csproj: Removing 1 duplicate 'Microsoft.NET.Sdk.Functions' entries

## PARAMETERS

### -Path
The path to a .sln or .??proj file, or a directory containing either.

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

### -Reason
Specifies that packages should only be upgraded based why they are outdated:
* Vulnerable: Only upgrade packages with known security vulnerabilities.
* Deprecated: Only upgrade packages marked as discouraged for any reason.
* Outdated: Upgrade all packages.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Vulnerable
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipPackages
Packages to ignore when upgrading.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @()
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

[Use-Command.ps1]()

[Write-Info.ps1]()

