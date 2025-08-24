<#
.SYNOPSIS
Displays requested system status values using powerline font characters.

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
'OSVersion','PowerShellCommand','PowerShellVersion','Uptime','UserName')]
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
    Import-CharConstants.ps1 'BUST IN SILHOUETTE' 'HOUSE BUILDING' 'SQUARED ID' 'PERSONAL COMPUTER' `
        'POWER SYMBOL' 'NEW MOON SYMBOL' 'HARD DISK' 'POLICE CARS REVOLVING LIGHT' -AsEmoji
    filter Format-Status
    {
        [CmdletBinding()][OutputType([string])] Param(
        [Parameter(ValueFromPipeline=$true)][string] $Status
        )
        switch($Status)
        {
            AdminIndicator { (Test-Administrator.ps1) ? ${POLICE CARS REVOLVING LIGHT} : '' }
            ComputerName {"${PERSONAL COMPUTER}$([Environment]::MachineName)"}
            DotNetVersion {"$(Get-Unicode.ps1 0xE77F).NET $([Environment]::Version)"}
            DriveUsage
            {
                ${HARD DISK} + ' ' + ((Get-PSDrive -PSProvider FileSystem |
                    ForEach-Object {"$(Get-Unicode.ps1 (0x1F311 + [math]::Round((5*$_.Used)/($_.Used+$_.Free)) ))$($_.Name)"}) -join ' ')
            }
            ExplorerUser
            {
                $euser = New-Object Management.ManagementObjectSearcher `
                    "select * from Win32_Process where ProcessID = $((Get-Process explorer)[0].Id)" |
                    ForEach-Object {$_.Get()} |
                    ForEach-Object {$_.GetOwner()} |
                    Select-Object -ExpandProperty User
                "${SQUARED ID} $euser"
            }
            GitUser {"$(Get-Unicode.ps1 0xF1D2)$(git config user.name) <$(git config user.email)>"}
            HomeDirectory {"${HOUSE BUILDING}$HOME"}
            OSVersion
            {
                $icon =
                    if($IsWindows) {Get-Unicode.ps1 0xF17A}
                    elseif($IsLinux) {Get-Unicode.ps1 0xF17C}
                    elseif($IsMacOS) {Get-Unicode.ps1 0xF179}
                "$icon$([Environment]::OSVersion.VersionString) $($PSVersionTable.OS)"
            }
            PowerShellCommand {"$(Get-Unicode.ps1 0xE86C)$([Environment]::ProcessPath) $([Environment]::CommandLine)"}
            PowerShellVersion {"$(Get-Unicode.ps1 0xE86C)PS $($PSVersionTable.PSVersion) $($PSVersionTable.PSEdition)"}
            Uptime {"${POWER SYMBOL} $(Get-Uptime)"}
            UserName {"${BUST IN SILHOUETTE}$env:USERNAME"}
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
