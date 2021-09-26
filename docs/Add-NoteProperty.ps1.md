---
external help file: -help.xml
Module Name:
online version:
schema: 2.0.0
---

# Add-NoteProperty.ps1

## SYNOPSIS
Adds a NoteProperty to a PSObject, calculating the value with the object in context.

## SYNTAX

```
Add-NoteProperty.ps1 [-Name] <String> [-Value] <ScriptBlock> [-Properties <String[]>] -InputObject <PSObject>
 [-PassThru] [-Force] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Get-ChildItem Get-*.ps1 |Add-NoteProperty.ps1 Size {Format-ByteUnits.ps1 $Length -Precision 1} -Properties Length -PassThru |Format-Table Size,Name -AutoSize
```

Size   Name
----   ----
8.1KB  Get-AspNetEvents.ps1
840    Get-AssemblyFramework.ps1
7KB    Get-CertificatePath.ps1
1.5KB  Get-CertificatePermissions.ps1
38.3KB Get-CharacterDetails.ps1
1.1KB  Get-ClassicAspEvents.ps1
1.3KB  Get-CommandPath.ps1
1.2KB  Get-ConfigConnectionStringBuilders.ps1
4.9KB  Get-ConsoleColors.ps1
1.4KB  Get-ContentSecurityPolicy.ps1
617    Get-Dns.ps1
2.4KB  Get-EnumValues.ps1
6KB    Get-IisLog.ps1
1.9KB  Get-LibraryVulnerabilityInfo.ps1
2.7KB  Get-DotNetFrameworkVersions.ps1
969    Get-RepoName.ps1
3.3KB  Get-SslDetails.ps1
4.2KB  Get-SystemDetails.ps1
6.8KB  Get-TypeAccelerators.ps1
1.2KB  Get-XmlNamespaces.ps1

## PARAMETERS

### -Name
The name of the NoteProperty to add to the object.

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

### -Value
The expression to use to set the value of the NoteProperty.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
{{ Fill Properties Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Import

Required: False
Position: Named
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
The object to add the NoteProperty to.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PassThru
Returns the object with the NoteProperty added.
Normally there is no output.

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

### -Force
{{ Fill Force Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Void
### System.Management.Automation.PSObject
## NOTES

## RELATED LINKS

[Add-Member]()

