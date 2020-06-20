<#
.Synopsis
	Retrieves the a summary from the Chocolatey log.

.Parameter Position
	Indicates which Chocolatey run in the log to check.
	Use negative numbers to count from the end of the log.

.Parameter Level
	The lowest level of importance to include.

		* All, ActivityTracing, and Verbose include everything.
		* Information includes that level, plus Warning and Error.
		* Warning includes that level, plus Error.
		* Error only includes that level.
		* Critical and Off will exclude everything, since those levels aren't used.

.Link
	https://chocolatey.org/

.Link
	Import-Variables.ps1

.Example
	Read-ChocolateySummary.ps1 |Format-Table -AutoSize -Wrap

    LogTime               Level Text
    -------               ----- ----
    2020-01-31 13:07:00 Warning You have dotnetcore-sdk v3.1.100 installed. Version 3.1.101 is available based on your source(s).
    2020-01-31 13:08:03   Error dotnetcore-sdk not upgraded. An error occurred during installation:
                                 Already referencing a newer version of 'KB2999226'.
    2020-01-31 13:08:03   Error The upgrade of dotnetcore-sdk was NOT successful.
    2020-01-31 13:08:03   Error dotnetcore-sdk not upgraded. An error occurred during installation:
                                 Already referencing a newer version of 'KB2999226'.
    2020-01-31 13:08:08 Warning You have dropbox v88.4.172 installed. Version 89.4.278 is available based on your source(s).
    2020-01-31 13:08:17 Warning You have Firefox v72.0.1 installed. Version 72.0.2 is available based on your source(s).
    2020-01-31 13:08:24 Warning You have git v2.24.1.2 installed. Version 2.25.0 is available based on your source(s).
    2020-01-31 13:12:22 Warning You have GoogleChrome v79.0.3945.117 installed. Version 79.0.3945.130 is available based on your source(s).
    2020-01-31 13:12:37 Warning You have microsoft-windows-terminal v0.7.3451.0 installed. Version 0.8.10261.0 is available based on your source(s).
    2020-01-31 13:12:43   Error microsoft-windows-terminal not upgraded. An error occurred during installation:
                                 Already referencing a newer version of 'KB2999226'.
    2020-01-31 13:12:43   Error The upgrade of microsoft-windows-terminal was NOT successful.
    2020-01-31 13:12:43   Error microsoft-windows-terminal not upgraded. An error occurred during installation:
                                 Already referencing a newer version of 'KB2999226'.
    2020-01-31 13:12:49 Warning You have powershell-core v6.2.3 installed. Version 6.2.4 is available based on your source(s).
    2020-01-31 13:12:59 Warning If you started this package under PowerShell core, replacing an in-use version may be unpredictable, require multiple attempts or
                                produce errors.
    2020-01-31 13:16:04 Warning Environment Vars (like PATH) have changed. Close/reopen your shell to
                                 see the changes (or in powershell/cmd.exe just type `refreshenv`).
    2020-01-31 13:16:05 Warning You have slack v4.3.0 installed. Version 4.3.2 is available based on your source(s).
    2020-01-31 13:17:41 Warning You have thunderbird v68.4.1 installed. Version 68.4.2 is available based on your source(s).
    2020-01-31 13:18:58 Warning Chocolatey upgraded 9/64 packages. 2 packages failed.
                                 See the log for details (C:\ProgramData\chocolatey\logs\chocolatey.log).
    2020-01-31 13:18:58   Error Failures
    2020-01-31 13:18:58   Error - dotnetcore-sdk (exited 1) - dotnetcore-sdk not upgraded. An error occurred during installation:
                                 Already referencing a newer version of 'KB2999226'.
    2020-01-31 13:18:58   Error - microsoft-windows-terminal (exited 1) - microsoft-windows-terminal not upgraded. An error occurred during installation:
                                 Already referencing a newer version of 'KB2999226'.
#>

#Requires -Version 5.1
using namespace System.Diagnostics
[CmdletBinding()] Param(
[Parameter(Position=0)][int] $Position = -1,
[Parameter(Position=1)][Alias('Verbosity')][SourceLevels] $Level = 'Warning'
)
if($Level -eq 'All') {[SourceLevels] $Level = 'ActivityTracing'}
$linepattern = @'
(?msx) \A
(?<LogTime>\d{4}-\d{2}-\d{2} \s \d{2}:\d{2}:\d{2},\d{3}) \s
(?<ChocoPid>\d+) \s
(?<LevelMark>\[(?:INFO \s |WARN \s |ERROR)\] \s - \s (?:(?:VERBOSE|WARNING): \s )?)
(?<Text>.*)
\z
'@
foreach($line in ((Get-Content $env:ChocolateyInstall\logs\choco.summary.log -Raw) -split
	'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3} \d+ \[INFO \] - ={60}\r*\n',0,'Multiline')[$Position].Trim() -split
	'\r*\n(?=^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3} \d+ \[(?:INFO |WARN |ERROR)\] - )',0,'Multiline')
{
	if($line -notmatch $linepattern) {Write-Warning "Could not parse: $line"; continue}
	Import-Variables.ps1 $Matches
	[SourceLevels] $LogLevel = switch($LevelMark)
	{
		'[INFO ] - VERBOSE: ' {'Verbose'}
		'[INFO ] - '          {'Information'}
		'[WARN ] - WARNING: ' {'Warning'}
		'[WARN ] - '          {'Warning'}
		'[ERROR] - '          {'Error'}
	}
	if($LogLevel -eq 'Warning' -and $Text -eq 'Upgraded:') {[SourceLevels] $LogLevel = 'Information'}
	if($LogLevel -gt $Level) {continue}
	[pscustomobject]@{
		LogTime = [datetime]$LogTime.Replace([char]',','.')
		Level   = $LogLevel
		Text    = $Text.Trim()
	}
}
