<#
.SYNOPSIS
Displays requested system status values using powerline font characters.

.LINK
https://www.nerdfonts.com/cheat-sheet

.LINK
Get-Unicode.ps1

.FUNCTIONALITY
System and updates

.EXAMPLE
Show-Status.ps1 UserName HomeDirectory -Separator ' * '

( MyUserName * C:\Users\MyUserName )
(but using powerline graphics)
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
# The format to serialize the date as.
[Parameter(Position=0,Mandatory=$true,ValueFromRemainingArguments=$true)]
[ValidateSet('AdminIndicator','ComputerName','DotNetVersion','DriveUsage','ExplorerUser','GitUser','HomeDirectory',
'OSVersion','PowerShellCommand','PowerShellVersion','Updates','Uptime','UserName')]
[string[]] $Status,
# The separator to use between formatted dates.
[string] $Separator = " $(Get-Unicode.ps1 0x2022) ",
# The foreground console color to use.
[consolecolor] $ForegroundColor = $host.UI.RawUI.BackgroundColor,
# The background console color to use.
[consolecolor] $BackgroundColor = $host.UI.RawUI.ForegroundColor,
# Forces rerunning the command to update the cache.
[switch] $Force
)
Begin
{
    Import-CharConstants.ps1 -Alias @{
        USER       = 'BUST IN SILHOUETTE'
        HOUSE      = 'HOUSE BUILDING'
        COMPUTER   = 'PERSONAL COMPUTER'
        REDCIRCLE  = 'LARGE RED CIRCLE'
        BLUECIRCLE = 'LARGE BLUE CIRCLE'
        POWER      = 'POWER SYMBOL'
        HARDDISK   = 'HARD DISK'
        OVERLAP    = 'OVERLAP'
        REDX       = 'CROSS MARK'
        OK         = 'SQUARED OK'
        'UP!'      = 'SQUARED UP WITH EXCLAMATION MARK'
    } -AsEmoji

    function Get-WinGetTest
    {
        if(Get-Module Microsoft.WinGet.Client -ListAvailable)
        {{
            if(Get-WinGetPackage |
                Where-Object IsUpdateAvailable |
                Select-Object -First 1) {'winget'}
        }}
        elseif(Get-Command winget -CommandType Application -ErrorAction Ignore)
        {{
            if(winget list --upgrade-available --disable-interactivity |
                Select-String '^\d+ upgrades? available.$' |
                Select-Object -First 1) {'winget'}
        }}
        else
        {{$null}}
    }

    function Get-ChocoTest
    {{
        if(Get-Command choco -CommandType Application -ErrorAction Ignore)
        {
            if(choco outdated -r |Select-Object -First 1) {'choco'}
        }
    }}

    function Get-NpmTest
    {{
        if(Get-Command npm -CommandType Application -ErrorAction Ignore)
        {
            if(npm outdated -g -parseable |Select-Object -First 1) {'npm'}
        }
    }}

    function Get-PSModulesTest
    {{
        if(Get-OutdatedModules.ps1 |Select-Object -First 1) {'psmodules'}
    }}

    filter Format-Status
    {
        [CmdletBinding()][OutputType([string])] Param(
        [Parameter(ValueFromPipeline=$true)][string] $Status
        )
        switch($Status)
        {
            AdminIndicator { (Test-Administrator.ps1) ? $REDCIRCLE : $BLUECIRCLE }
            ComputerName {"$COMPUTER $([Environment]::MachineName)"}
            DotNetVersion {"$([char]0xE77F) .NET $([Environment]::Version)"}
            DriveUsage
            {
                $HARDDISK + ' ' + ((Get-PSDrive -PSProvider FileSystem |Where-Object {$null -ne $_.Free} |
                    ForEach-Object {"$(Get-Unicode.ps1 (0x1F311 + [math]::Round((5*$_.Used)/($_.Used+$_.Free)) ))$($_.Name)"}) -join ' ')
            }
            ExplorerUser
            {
                $euser = New-Object Management.ManagementObjectSearcher `
                    "select * from Win32_Process where ProcessID = $((Get-Process explorer)[0].Id)" |
                    ForEach-Object {$_.Get()} |
                    ForEach-Object {$_.GetOwner()} |
                    Select-Object -ExpandProperty User
                "$OVERLAP $euser"
            }
            GitUser {(git config user.name) ?
                "$([char]0xF1D2) $(git config user.name) <$(git config user.email)>" :
                "$([char]0xF1D2) $REDX"}
            HomeDirectory {"$HOUSE $HOME"}
            OSVersion
            {
                if($IsWindows) {"$([char]0xF17A) $([Environment]::OSVersion.VersionString)"}
                elseif($IsLinux) {"$([char]0xF17C) $([Environment]::OSVersion.VersionString) $($PSVersionTable.OS)"}
                elseif($IsMacOS) {"$([char]0xF179) $([Environment]::OSVersion.VersionString) $($PSVersionTable.OS)"}
            }
            PowerShellCommand {"$([char]0xE86C) $([Environment]::ProcessPath) $([Environment]::CommandLine)"}
            PowerShellVersion {"$([char]0xE86C) PS $($PSVersionTable.PSVersion) $($PSVersionTable.PSEdition)"}
            Updates
            {
                $updates = @(
                    (Invoke-CachedCommand.ps1 (Get-ChocoTest) -ExpiresAfter 20:00 -Force:$Force)
                    (Invoke-CachedCommand.ps1 (Get-WingetTest) -ExpiresAfter 20:00 -Force:$Force)
                    (Invoke-CachedCommand.ps1 (Get-NpmTest) -ExpiresAfter 20:00 -Force:$Force)
                    (Invoke-CachedCommand.ps1 (Get-PSModulesTest) -ExpiresAfter 20:00 -Force:$Force)
                ) |Where-Object {$_}
                $updates ? "${UP!} $updates" : $OK
            }
            Uptime {"$POWER$(Get-Uptime)"}
            UserName {"$USER $env:USERNAME"}
            default {$_}
        }
    }
}
Process
{
	Write-Info.ps1 (Get-Unicode.ps1 0xE0B6) -ForegroundColor $BackgroundColor -NoNewline
	Write-Info.ps1 ' ' -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline
	Write-Info.ps1 (($Status |Format-Status) -join $Separator) `
		-ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline
	Write-Info.ps1 ' ' -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline
	Write-Info.ps1 (Get-Unicode.ps1 0xE0B4) -fore $BackgroundColor
}
