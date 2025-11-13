<#
.SYNOPSIS
Adds or updates a Windows Terminal command profile.
#>

#Requires -Version 7
[CmdletBinding()] Param(
[Parameter(Position=1)][string] $Name,
[Parameter(Position=2)][string] $CommandLine
)
DynamicParam
{
    $Script:data = Get-Content ([io.path]::ChangeExtension($PSCommandPath, 'json')) -Raw |ConvertFrom-Json -AsHashtable
    $data.Keys |Add-DynamicParam.ps1 -Name Type -Type string -Position 0 -Mandatory
    $DynamicParams
}
Begin
{
    function Initialize-Variables
    {
        $Script:settings = Join-Path $env:LOCALAPPDATA Microsoft 'Windows Terminal' settings.json
        $Script:profiles = Select-Json.ps1 -JsonPointer /profiles/list -Path $Script:settings
    }

    function Get-TerminalProfileByGuid
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,Mandatory=$true)][guid] $Guid
        )
        return $Script:profiles |Where-Object source -eq $Guid.ToString('B')
    }

    function Get-TerminalProfileBySource
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,Mandatory=$true)][string] $Source
        )
        return $Script:profiles |Where-Object source -eq $Source
    }

    function Get-TerminalProfileByName
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,ValueFromRemainingArguments=$true)][AllowNull()][string[]] $Name
        )
        return $Script:profiles |Where-Object name -in $Name |Select-Object -First 1
    }

    function Get-TerminalProfile
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,Mandatory=$true)][string] $Type,
        [Parameter(Position=1,Mandatory=$true)][string] $Name
        )
        switch($Type)
        {
            pwsh { return (Get-TerminalProfileByGuid 574e775e-4f2a-5b96-ac1e-a2962a402336) `
                ?? (Get-TerminalProfileBySource Windows.Terminal.PowershellCore) `
                ?? (Get-TerminalProfileByName PowerShell 'PowerShell Core' 'PowerShell 7') `
                ?? $Script:data[$_] }
            powershell { return (Get-TerminalProfileByGuid 61c54bbd-c2c6-5271-96e7-009a87ff44bf) `
                ?? (Get-TerminalProfileByName 'Windows PowerShell') `
                ?? $Script:data[$_] }
            wsl { return (Get-TerminalProfileByGuid 2c4de342-38b7-51cf-b940-2309a097f518) `
                ?? (Get-TerminalProfileBySource Windows.Terminal.Wsl) `
                ?? (Get-TerminalProfileByName Ubuntu) `
                ?? $Script:data[$_] }
            default { return (Get-TerminalProfileByName $Name) ?? $Script:data[$_] }
        }
    }

    function Update-TerminalProfile
    {
        Initialize-Variables
        $termprofile = Get-TerminalProfile $Type $Name
        if(!$termprofile.ContainsKey('guid') -or !$termprofile['guid']) { $termprofile['guid'] = (New-Guid).ToString('B') }
        if($Name) { $termprofile['guid'] = $Name }
        if($CommandLine) { $termprofile['commandline'] = $CommandLine }
        for($position = 0; $position -lt $Script:profiles; $position++)
        {
            if($Script:profiles[$position]['guid'] -eq $termprofile['guid']) {break}
        }
        Copy-Item $Script:settings ([io.path]::ChangeExtension($Script:settings, (Get-Date -Format yyyyMMdd\THHmmss)))
        Set-Json.ps1 -JsonPointer "/profiles/list/$position" -Path $Script:settings
    }
}
Process { Update-TerminalProfile }
