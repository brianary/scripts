<script data-goatcounter="https://webcoderscripts.goatcounter.com/count" async src="//gc.zgo.at/count.js"></script>

[![Pester tests status](https://github.com/brianary/scripts/actions/workflows/pester.yml/badge.svg)][pester.yml]
[![Pester tests results](https://gist.githubusercontent.com/brianary/4642e5c804aa1b40738def5a7c03607a/raw/badge.svg)][pester.yml]
[![Pester tests coverage](https://img.shields.io/badge/Pester_coverage-3196_‱-orange
red)](https://github.com/brianary/scripts/tree/main/test)
[![GitHub license badge](https://badgen.net/github/license/brianary/Scripts?icon=github)](https://mit-license.org/ "MIT License")
[![GitHub stars badge](https://badgen.net/github/stars/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/stargazers "Stars")
[![GitHub watchers badge](https://badgen.net/github/watchers/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/watchers "Watchers")
[![GitHub forks badge](https://badgen.net/github/forks/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/network/members "Forks")
[![GitHub issues badge](https://badgen.net/github/open-issues/brianary/Scripts?icon=github)](https://github.com/brianary/scripts/issues "Issues")
[![GitHub commits badge](https://badgen.net/github/commits/brianary/Scripts/main?icon=git)](https://github.com/brianary/scripts/commits/main "Commits")
[![GitHub last commit badge](https://badgen.net/github/last-commit/brianary/Scripts/main?icon=git)](https://github.com/brianary/scripts/commits/main "Last commit")
[![Mastodon: @dataelemental@mastodon.social](https://badgen.net/badge/@dataelemental/@mastodon.social/blue?icon=mastodon)](https://mastodon.social/@dataelemental "DataElemental Mastodon profile")
[![Mastodon: @brianary@mastodon.spotek.io](https://badgen.net/mastodon/follow/brianary@mastodon.spotek.io?icon=mastodon)](https://mastodon.spotek.io/@brianary "brianary Mastodon profile")

[pester.yml]: https://github.com/brianary/scripts/actions/workflows/pester.yml "Pester test run history"

Scripts from the [Scripts](https://github.com/brianary/Scripts/) repo.


### Command

- &#x1F199; **[Hide-Command.ps1](Hide-Command.ps1.md)**: Make a command unavailable.
- &#x1F199; **[Invoke-CommandWithParams.ps1](Invoke-CommandWithParams.ps1.md)**: Execute a command by using matching dictionary entries as parameters.
- &#x1F199; **[Use-Command.ps1](Use-Command.ps1.md)**: Checks for the existence of the given command, and adds if missing and a source is defined.

### Configuration

- &#x1F199; **[Use-NetMailConfig.ps1](Use-NetMailConfig.ps1.md)**: Use .NET configuration to set defaults for Send-MailMessage.

### Console

- **[Set-ConsoleColorTheme.ps1](Set-ConsoleColorTheme.ps1.md)**: Overrides ConsoleClass window color palette entries with a preset color theme.

### Credential

- &#x1F199; **[Get-CachedCredential.ps1](Get-CachedCredential.ps1.md)**: Return a credential from secure storage, or prompt the user for it if not found.
- &#x1F199; **[Remove-CachedCredential.ps1](Remove-CachedCredential.ps1.md)**: Removes a credential from secure storage.
- **[Save-Secret.ps1](Save-Secret.ps1.md)**: Sets a secret in a secret vault with metadata.

### Data formats

- **[Test-Windows1252.ps1](Test-Windows1252.ps1.md)**: Determines whether a file contains Windows-1252 bytes that are invalid UTF-8 bytes.

### Database

- &#x1F199; **[ConvertFrom-DataRow.ps1](ConvertFrom-DataRow.ps1.md)**: Converts a DataRow object to a PSObject, Hashtable, or single value.
- &#x1F199; **[Use-SqlcmdParams.ps1](Use-SqlcmdParams.ps1.md)**: Use the calling script parameters to set Invoke-Sqlcmd defaults.

### Date and time

- **[ConvertTo-LogParserTimestamp.ps1](ConvertTo-LogParserTimestamp.ps1.md)**: Formats a datetime as a LogParser literal.

### DotNet

- **[Get-DotNetFrameworkVersions.ps1](Get-DotNetFrameworkVersions.ps1.md)**: Determine which .NET Frameworks are installed on the requested system.
- **[Get-DotNetGlobalTools.ps1](Get-DotNetGlobalTools.ps1.md)**: Returns a list of global dotnet tools.
- **[Get-DotNetVersions.ps1](Get-DotNetVersions.ps1.md)**: Determine which .NET Core & Framework versions are installed.
- &#x1F199; **[Update-DotNetPackages.ps1](Update-DotNetPackages.ps1.md)**: Updates NuGet packages for a .NET solution or project.

### EnvironmentVariables

- **[Compress-EnvironmentVariables.ps1](Compress-EnvironmentVariables.ps1.md)**: Replaces each of the longest matching parts of a string with an embedded environment variable with that value.

### Files

- **[Join-FileName.ps1](Join-FileName.ps1.md)**: Combines a filename with a string.
- &#x1F199; **[Measure-Caches.ps1](Measure-Caches.ps1.md)**: Returns a list of matching cache directories, and their sizes, sorted.
- **[New-Shortcut.ps1](New-Shortcut.ps1.md)**: Create a Windows shortcut.
- **[Remove-LockyFile.ps1](Remove-LockyFile.ps1.md)**: Removes a file that may be prone to locking.
- **[Test-LockedFile.ps1](Test-LockedFile.ps1.md)**: Returns true if the specified file is locked.

### Packages and libraries

- **[Find-ProjectPackages.ps1](Find-ProjectPackages.ps1.md)**: Find modules used in projects.

### PowerShell

- &#x1F199; **[Add-ScopeLevel.ps1](Add-ScopeLevel.ps1.md)**: Convert a scope level to account for another call stack level.
- &#x1F195; **[Convert-ExternalScriptToModule.ps1](Convert-ExternalScriptToModule.ps1.md)**: Convert a script from external script usage to module cmdlet usage.

### Scheduled Tasks

- **[Backup-SchTasks.ps1](Backup-SchTasks.ps1.md)**: Exports the local list of Scheduled Tasks into a single XML file.
- &#x1F199; **[ConvertFrom-CimInstance.ps1](ConvertFrom-CimInstance.ps1.md)**: Convert a CimInstance object to a PSObject.
- **[Copy-SchTasks.ps1](Copy-SchTasks.ps1.md)**: Copy scheduled jobs from another computer to this one, using a GUI list to choose jobs.
- **[Get-SimpleSchTasks.ps1](Get-SimpleSchTasks.ps1.md)**: Returns simple scheduled task info.
- **[Restore-SchTasks.ps1](Restore-SchTasks.ps1.md)**: Imports from a single XML file into the local Scheduled Tasks.
- **[Set-SchTaskMsa.ps1](Set-SchTaskMsa.ps1.md)**: Sets a Scheduled Task's runtime user as the given gMSA/MSA.

### Scripts

- &#x1F199; **[New-PesterTests.ps1](New-PesterTests.ps1.md)**: Creates a new Pester testing script from a script's examples and parameter sets.
- &#x1F199; **[New-Script.ps1](New-Script.ps1.md)**: Creates a simple boilerplate script.
- **[Optimize-Help.ps1](Optimize-Help.ps1.md)**: Cleans up comment-based help blocks by fully unindenting and capitalizing dot keywords.
- &#x1F199; **[Rename-Script.ps1](Rename-Script.ps1.md)**: Renames all instances of a script, and updates any usage of it.

### Search and replace

- **[Find-Lines.ps1](Find-Lines.ps1.md)**: Searches a specific subset of files for lines matching a pattern.

### System and updates

- **[Convert-ChocolateyToWinget.ps1](Convert-ChocolateyToWinget.ps1.md)**: Change from managing various packages with Chocolatey to WinGet.
- **[Export-EdgeKeywords.ps1](Export-EdgeKeywords.ps1.md)**: Returns the configured search keywords from an Edge SQLite file.
- **[Export-InstalledPackages.ps1](Export-InstalledPackages.ps1.md)**: Exports the list of packages installed by various tools.
- **[Find-InstalledPrograms.ps1](Find-InstalledPrograms.ps1.md)**: Searches installed programs.
- **[Get-SystemDetails.ps1](Get-SystemDetails.ps1.md)**: Collects some useful system hardware and operating system details via CIM.
- **[Import-EdgeKeywords.ps1](Import-EdgeKeywords.ps1.md)**: Adds search keywords to an Edge SQLite profile configuration.
- &#x1F199; **[Read-ChocolateySummary.ps1](Read-ChocolateySummary.ps1.md)**: Retrieves the a summary from the Chocolatey log.
- &#x1F199; **[Update-Everything.ps1](Update-Everything.ps1.md)**: Updates everything it can on the system.
- **[Use-Java.ps1](Use-Java.ps1.md)**: Switch the Java version for the current process by modifying environment variables.

### Unicode

- **[Get-UnicodeData.ps1](Get-UnicodeData.ps1.md)**: Returns the current (cached) Unicode character data.

### Windows Terminal

- &#x1F199; **[Set-TerminalProfile.ps1](Set-TerminalProfile.ps1.md)**: Adds or updates a Windows Terminal command profile.
- **[Test-WindowsTerminal.ps1](Test-WindowsTerminal.ps1.md)**: Returns true if PowerShell is running within Windows Terminal.

### Other

- &#x1F199; **[Backup-Workstation.ps1](Backup-Workstation.ps1.md)**: Adds various configuration files and exported settings to a ZIP file.
- &#x1F199; **[Export-Readme.ps1](Export-Readme.ps1.md)**: Generate README.md file for the scripts repo.
- **[Get-ADServiceAccountInfo.ps1](Get-ADServiceAccountInfo.ps1.md)**: Lists the Global Managed Service Accounts for the domain, including the computers they are bound to.
- **[Get-AspNetEvents.ps1](Get-AspNetEvents.ps1.md)**: Parses ASP.NET errors from the event log on the given server.
- **[Get-IisLog.ps1](Get-IisLog.ps1.md)**: Easily query IIS logs.
- **[Get-PathUsage.ps1](Get-PathUsage.ps1.md)**: Returns the list of directories in the path, and the commands found in each.
- **[Measure-Indents.ps1](Measure-Indents.ps1.md)**: Measures the indentation characters used in a text file.
- **[Measure-StandardDeviation.ps1](Measure-StandardDeviation.ps1.md)**: Calculate the standard deviation of numeric values.
- **[Measure-TextFile.ps1](Measure-TextFile.ps1.md)**: Counts each type of indent and line ending.
- &#x1F199; **[New-RandomVehicle.ps1](New-RandomVehicle.ps1.md)**: Generates random vehicle details with a valid VIN.
- &#x1F199; **[Optimize-Path.ps1](Optimize-Path.ps1.md)**: Sorts, prunes, and normalizes both user and system Path entries.
- **[Repair-AppxPackages.ps1](Repair-AppxPackages.ps1.md)**: Re-registers all installed Appx packages.
- &#x1F199; **[Restore-Workstation.ps1](Restore-Workstation.ps1.md)**: Restores various configuration files and exported settings from a ZIP file.
- **[Send-MailMessageFile.ps1](Send-MailMessageFile.ps1.md)**: Sends emails from a drop folder using .NET config defaults.
