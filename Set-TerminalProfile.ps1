<#
.SYNOPSIS
Adds or updates a Windows Terminal command profile.

.FUNCTIONALITY
Windows Terminal

.PARAMETER Type
The CLI application to configure.

.PARAMETER Name
The name of the profile.

.PARAMETER CommandLine
The command line to use in the profile.

.LINK
https://aka.ms/terminal-documentation

.LINK
https://aka.ms/terminal-profiles-schema

.LINK
https://gist.github.com/shanselman/4d954449914664024ee20ba10c2aaa0d

.LINK
https://learn.microsoft.com/en-us/windows/terminal/json-fragment-extensions

.LINK
https://github.com/microsoft/terminal/issues/1918#issuecomment-2452815871

.EXAMPLE
Set-TerminalProfile.ps1 pwsh

Adds a default profile for PowerShell Core.

.EXAMPLE
Set-TerminalProfile.ps1 fsi

Adds a default profile for F# Interactive.

.EXAMPLE
Set-TerminalProfile.ps1 ssh servername 'ssh username@servername'

Adds an ssh profile named "servername", using the specified command line.
#>

#Requires -Version 7
[CmdletBinding()] Param()
DynamicParam
{
    $Script:data = Get-Content ([io.path]::ChangeExtension($PSCommandPath, 'json')) -Raw |ConvertFrom-Json -AsHashtable
    $data.Keys |Add-DynamicParam.ps1 -Name Type -Type string -Position 0 -Mandatory
    Add-DynamicParam.ps1 -Name Name -Type string -Position 1
    Add-DynamicParam.ps1 -Name CommandLine -Type string -Position 2
    $DynamicParams
}
Begin
{
    function Initialize-Variables
    {
        $Script:settings = Join-Path $env:LOCALAPPDATA Packages Microsoft.WindowsTerminal_8wekyb3d8bbwe LocalState settings.json
        if(!(Test-Path $Script:settings -Type Leaf)) {throw "Could not find $Script:settings"}
        $Script:profiles = Select-Json.ps1 -JsonPointer /profiles/list -Path $Script:settings
    }

    function Get-TerminalProfileByGuid
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,Mandatory=$true)][guid] $Guid
        )
        return $Script:profiles |Where-Object {$_.ContainsKey('guid')} |Where-Object guid -eq $Guid.ToString('B')
    }

    function Get-TerminalProfileBySource
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,Mandatory=$true)][string] $Source
        )
        return $Script:profiles |Where-Object {$_.ContainsKey('source')} |Where-Object source -eq $Source
    }

    function Get-TerminalProfileByName
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,ValueFromRemainingArguments=$true)][AllowNull()][string[]] $Name
        )
        return $Script:profiles |Where-Object {$_.ContainsKey('name')} |Where-Object name -in $Name |Select-Object -First 1
    }

    function Get-TerminalProfile
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,Mandatory=$true)][string] $Type,
        [Parameter(Position=1,Mandatory=$true)][AllowEmptyString()][string] $Name
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
            azcs { return (Get-TerminalProfileByGuid b453ae62-4e3d-5e58-b989-0a998ec441b8) `
                ?? (Get-TerminalProfileBySource Windows.Terminal.Azure) `
                ?? (Get-TerminalProfileByName Azure Cloud Shell) `
                ?? $Script:data[$_] }
            default
            {
                if(!$Name) {return $Script:data[$_]}
                else {return (Get-TerminalProfileByName $Name) ?? $Script:data[$_]}
            }
        }
    }

    function Initialize-TerminalProfile
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0)][AllowEmptyString()][string] $Name,
        [Parameter(Position=1)][AllowEmptyString()][string] $CommandLine,
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)][pscustomobject] $InputObject
        )
        if(!$InputObject.ContainsKey('guid') -or !$InputObject['guid']) { $InputObject['guid'] = (New-Guid).ToString('B') }
        if($Name) { $InputObject['name'] = $Name }
        if($CommandLine) { $InputObject['commandline'] = $CommandLine }
        if($InputObject.ContainsKey('backgroundImage') -and $InputObject['backgroundImage'] -notlike '*:*')
        {
            $InputObject['backgroundImage'] = Join-Path $PSScriptRoot logos $InputObject['backgroundImage']
        }
        if($InputObject.ContainsKey('icon') -and $InputObject['icon'] -notlike '*:*')
        {
            $InputObject['icon'] = Join-Path $PSScriptRoot logos $InputObject['icon']
        }
        return $InputObject
    }

    function Update-TerminalProfile
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,Mandatory=$true)][string] $Type,
        [Parameter(Position=1)][string] $Name,
        [Parameter(Position=2)][string] $CommandLine
        )
        Initialize-Variables
        $termprofile = Get-TerminalProfile $Type $Name |Initialize-TerminalProfile $Name $CommandLine
        Write-Info.ps1 'Found profile:' -fg DarkGray
        $termprofile |Format-Table -AutoSize |Out-String |Write-Info.ps1 -fg Gray
        for($position = 0; $position -lt $Script:profiles.Count; $position++)
        {
            if($Script:profiles[$position]['guid'] -eq $termprofile['guid']) {break}
        }
        Write-Info.ps1 "Setting position $position"
        Copy-Item $Script:settings ([io.path]::ChangeExtension($Script:settings, (Get-Date -Format yyyyMMdd\THHmmss)))
        Set-Json.ps1 -JsonPointer "/profiles/list/$position" -PropertyValue $termprofile -Path $Script:settings
    }
}
Process { Update-TerminalProfile @PSBoundParameters }
