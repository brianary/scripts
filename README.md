Useful General-Purpose Scripts
==============================

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
[![Mastodon: @brianary@mastodon.spotek.io](https://badgen.net/mastodon/follow/brianary@mastodon.spotek.io?icon=mastodon)](https://mastodon.spotek.io/@brianary "Mastodon profile")

[pester.yml]: https://github.com/brianary/scripts/actions/workflows/pester.yml "Pester test run history"

> [!NOTE]
> Many scripts have been moved into modules to improve their usability!
> See **[ModernConveniences][]** and the [scripts-to-modules.json roadmap][].
> Use **[Convert-ExternalScriptToModule.ps1](Convert-ExternalScriptToModule.ps1)** to convert your scripts!

[ModernConveniences]: https://github.com/brianary/ModernConveniences/ "A collection of general-purpose functions for objects, properties, and more."
[scripts-to-modules.json roadmap]: scripts-to-modules.json "The plan to divide the scripts into modules by purpose."

This repo contains a collection of generally useful scripts (mostly Windows PowerShell).

See [PS5](PS5) for legacy scripts, [syscfg](syscfg) for single-use system config scripts.

PowerShell Scripts
------------------

### Command

- :up: **[Hide-Command.ps1](Hide-Command.ps1)**: Make a command unavailable.
- :up: **[Invoke-CommandWithParams.ps1](Invoke-CommandWithParams.ps1)**: Execute a command by using matching dictionary entries as parameters.
- :up: **[Use-Command.ps1](Use-Command.ps1)**: Checks for the existence of the given command, and adds if missing and a source is defined.

### Configuration

- :up: **[Use-NetMailConfig.ps1](Use-NetMailConfig.ps1)**: Use .NET configuration to set defaults for Send-MailMessage.

### Console

- **[Set-ConsoleColorTheme.ps1](Set-ConsoleColorTheme.ps1)**: Overrides ConsoleClass window color palette entries with a preset color theme.

### Credential

- :up: **[Get-CachedCredential.ps1](Get-CachedCredential.ps1)**: Return a credential from secure storage, or prompt the user for it if not found.
- :up: **[Remove-CachedCredential.ps1](Remove-CachedCredential.ps1)**: Removes a credential from secure storage.
- **[Save-Secret.ps1](Save-Secret.ps1)**: Sets a secret in a secret vault with metadata.

### Data formats

- **[Test-Windows1252.ps1](Test-Windows1252.ps1)**: Determines whether a file contains Windows-1252 bytes that are invalid UTF-8 bytes.

### Database

- :up: **[ConvertFrom-DataRow.ps1](ConvertFrom-DataRow.ps1)**: Converts a DataRow object to a PSObject, Hashtable, or single value.
- :up: **[Use-SqlcmdParams.ps1](Use-SqlcmdParams.ps1)**: Use the calling script parameters to set Invoke-Sqlcmd defaults.

### Date and time

- **[ConvertTo-LogParserTimestamp.ps1](ConvertTo-LogParserTimestamp.ps1)**: Formats a datetime as a LogParser literal.

### DotNet

- **[Get-DotNetFrameworkVersions.ps1](Get-DotNetFrameworkVersions.ps1)**: Determine which .NET Frameworks are installed on the requested system.
- **[Get-DotNetGlobalTools.ps1](Get-DotNetGlobalTools.ps1)**: Returns a list of global dotnet tools.
- **[Get-DotNetVersions.ps1](Get-DotNetVersions.ps1)**: Determine which .NET Core & Framework versions are installed.
- :up: **[Update-DotNetPackages.ps1](Update-DotNetPackages.ps1)**: Updates NuGet packages for a .NET solution or project.

### EnvironmentVariables

- **[Compress-EnvironmentVariables.ps1](Compress-EnvironmentVariables.ps1)**: Replaces each of the longest matching parts of a string with an embedded environment variable with that value.

### Files

- **[Join-FileName.ps1](Join-FileName.ps1)**: Combines a filename with a string.
- :up: **[Measure-Caches.ps1](Measure-Caches.ps1)**: Returns a list of matching cache directories, and their sizes, sorted.
- **[New-Shortcut.ps1](New-Shortcut.ps1)**: Create a Windows shortcut.
- **[Remove-LockyFile.ps1](Remove-LockyFile.ps1)**: Removes a file that may be prone to locking.
- **[Test-LockedFile.ps1](Test-LockedFile.ps1)**: Returns true if the specified file is locked.

### Packages and libraries

- **[Find-ProjectPackages.ps1](Find-ProjectPackages.ps1)**: Find modules used in projects.

### PowerShell

- :up: **[Add-ScopeLevel.ps1](Add-ScopeLevel.ps1)**: Convert a scope level to account for another call stack level.
- :new: **[Convert-ExternalScriptToModule.ps1](Convert-ExternalScriptToModule.ps1)**: Convert a script from external script usage to module cmdlet usage.

### Scheduled Tasks

- **[Backup-SchTasks.ps1](Backup-SchTasks.ps1)**: Exports the local list of Scheduled Tasks into a single XML file.
- :up: **[ConvertFrom-CimInstance.ps1](ConvertFrom-CimInstance.ps1)**: Convert a CimInstance object to a PSObject.
- **[Copy-SchTasks.ps1](Copy-SchTasks.ps1)**: Copy scheduled jobs from another computer to this one, using a GUI list to choose jobs.
- **[Get-SimpleSchTasks.ps1](Get-SimpleSchTasks.ps1)**: Returns simple scheduled task info.
- **[Restore-SchTasks.ps1](Restore-SchTasks.ps1)**: Imports from a single XML file into the local Scheduled Tasks.
- **[Set-SchTaskMsa.ps1](Set-SchTaskMsa.ps1)**: Sets a Scheduled Task's runtime user as the given gMSA/MSA.

### Scripts

- :up: **[New-PesterTests.ps1](New-PesterTests.ps1)**: Creates a new Pester testing script from a script's examples and parameter sets.
- :up: **[New-Script.ps1](New-Script.ps1)**: Creates a simple boilerplate script.
- **[Optimize-Help.ps1](Optimize-Help.ps1)**: Cleans up comment-based help blocks by fully unindenting and capitalizing dot keywords.
- :up: **[Rename-Script.ps1](Rename-Script.ps1)**: Renames all instances of a script, and updates any usage of it.

### Search and replace

- **[Find-Lines.ps1](Find-Lines.ps1)**: Searches a specific subset of files for lines matching a pattern.

### System and updates

- **[Convert-ChocolateyToWinget.ps1](Convert-ChocolateyToWinget.ps1)**: Change from managing various packages with Chocolatey to WinGet.
- **[Export-EdgeKeywords.ps1](Export-EdgeKeywords.ps1)**: Returns the configured search keywords from an Edge SQLite file.
- **[Export-InstalledPackages.ps1](Export-InstalledPackages.ps1)**: Exports the list of packages installed by various tools.
- **[Find-InstalledPrograms.ps1](Find-InstalledPrograms.ps1)**: Searches installed programs.
- **[Get-SystemDetails.ps1](Get-SystemDetails.ps1)**: Collects some useful system hardware and operating system details via CIM.
- **[Import-EdgeKeywords.ps1](Import-EdgeKeywords.ps1)**: Adds search keywords to an Edge SQLite profile configuration.
- :up: **[Read-ChocolateySummary.ps1](Read-ChocolateySummary.ps1)**: Retrieves the a summary from the Chocolatey log.
- :up: **[Update-Everything.ps1](Update-Everything.ps1)**: Updates everything it can on the system.
- **[Use-Java.ps1](Use-Java.ps1)**: Switch the Java version for the current process by modifying environment variables.

### Unicode

- **[Get-UnicodeData.ps1](Get-UnicodeData.ps1)**: Returns the current (cached) Unicode character data.

### Windows Terminal

- :up: **[Set-TerminalProfile.ps1](Set-TerminalProfile.ps1)**: Adds or updates a Windows Terminal command profile.
- **[Test-WindowsTerminal.ps1](Test-WindowsTerminal.ps1)**: Returns true if PowerShell is running within Windows Terminal.

### Other

- :up: **[Backup-Workstation.ps1](Backup-Workstation.ps1)**: Adds various configuration files and exported settings to a ZIP file.
- :up: **[Export-Readme.ps1](Export-Readme.ps1)**: Generate README.md file for the scripts repo.
- **[Get-ADServiceAccountInfo.ps1](Get-ADServiceAccountInfo.ps1)**: Lists the Global Managed Service Accounts for the domain, including the computers they are bound to.
- **[Get-AspNetEvents.ps1](Get-AspNetEvents.ps1)**: Parses ASP.NET errors from the event log on the given server.
- **[Get-IisLog.ps1](Get-IisLog.ps1)**: Easily query IIS logs.
- **[Get-PathUsage.ps1](Get-PathUsage.ps1)**: Returns the list of directories in the path, and the commands found in each.
- **[Measure-Indents.ps1](Measure-Indents.ps1)**: Measures the indentation characters used in a text file.
- **[Measure-StandardDeviation.ps1](Measure-StandardDeviation.ps1)**: Calculate the standard deviation of numeric values.
- **[Measure-TextFile.ps1](Measure-TextFile.ps1)**: Counts each type of indent and line ending.
- :up: **[New-RandomVehicle.ps1](New-RandomVehicle.ps1)**: Generates random vehicle details with a valid VIN.
- :up: **[Optimize-Path.ps1](Optimize-Path.ps1)**: Sorts, prunes, and normalizes both user and system Path entries.
- **[Repair-AppxPackages.ps1](Repair-AppxPackages.ps1)**: Re-registers all installed Appx packages.
- :up: **[Restore-Workstation.ps1](Restore-Workstation.ps1)**: Restores various configuration files and exported settings from a ZIP file.
- **[Send-MailMessageFile.ps1](Send-MailMessageFile.ps1)**: Sends emails from a drop folder using .NET config defaults.

F# Scripts
----------
- **[NCrontab Schedule Test](https://webcoder.info/scripts/Test-NCrontab.html)**: Returns a sampling of the next several date & times scheduled by an NCrontab string.
- **[Parse Unicode data](https://webcoder.info/scripts/UnicodeData.html)**: Experiment with CSV type provider to read Unicode data.
- **[US Federal Holiday Detection](https://webcoder.info/scripts/USFederalHolidays.html)**: Here's how to determine whether a date is a US federal holiday using F#.

Office VBA Scripts
------------------
- **[OutlookExpireTag.vba](OutlookExpireTag.vba)**: Too many emails remain beyond their period of relevance: daily personnel schedule changes, found item notices, office food notices, server reboot notices, weather/traffic warnings, &c. This Outlook script will allow specifying an expiration date as a hashtag in the subject of outgoing emails, since Outlook does such a good job of hiding the UI for that field. -BL 
- **[OutlookPasteFormattedIndented.vba](OutlookPasteFormattedIndented.vba)**: Outlook will strip single-space indents when displaying emails. If you've got, for example, syntax highlighted source code that employs any indentation of only one space, you'll want to add two spaces to the each line (adding one will not appear for text that isn't indented). This Outlook script will paste formatted text, and indent it. Requires Tools -> References -> Microsoft Word 14.0 Object Library (later versions may also work) 
- **[OutlookPasteTsvTable.vba](OutlookPasteTsvTable.vba)**: This Outlook VBA Sub can be connected to a toolbar button for pasting TSV data as an attractive, formatted table. -BL Requires Tools -> References -> Microsoft Word 14.0 Object Library (later versions may also work) 

<!-- generated 09/06/2026 21:10:41 -->
