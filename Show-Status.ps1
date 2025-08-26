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
[consolecolor] $BackgroundColor = $host.UI.RawUI.ForegroundColor
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
        'UP!'      = 'SQUARED UP WITH EXCLAMATION MARK'
    } -AsEmoji
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
            GitUser {"$([char]0xF1D2) $(git config user.name) <$(git config user.email)>"}
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
                ${UP!} + ' ' + (@(
                    ((Get-Command choco -ErrorAction Ignore) -and $(Invoke-CachedCommand.ps1 { choco outdated -r } -ExpiresAfter 20:00)) ? 'choco' : $null
                    ((Get-Command winget -ErrorAction Ignore) -and $(Invoke-CachedCommand.ps1 { winget list --upgrade-available } -ExpiresAfter 20:00)) ? 'winget' : $null
                ) |Where-Object {$_}) -join ' '
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
