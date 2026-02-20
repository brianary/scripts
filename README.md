Useful General-Purpose Scripts
==============================

[![Pester tests results](https://gist.githubusercontent.com/brianary/4642e5c804aa1b40738def5a7c03607a/raw/badge.svg)][pester.yml]
[![Pester tests coverage](https://img.shields.io/badge/Pester_coverage-3334_%E2%80%B1-orangered)](https://github.com/brianary/scripts/tree/main/test)
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

This repo contains a collection of generally useful scripts (mostly Windows PowerShell).

See [PS5](PS5) for legacy scripts, [syscfg](syscfg) for single-use system config scripts.

PowerShell Scripts
------------------

### Clipboard

- **[Convert-ClipboardTsvToHtml.ps1](Convert-ClipboardTsvToHtml.ps1)**: Parses TSV clipboard data into HTML table data which is copied back to the clipboard.
- **[Import-ClipboardTsv.ps1](Import-ClipboardTsv.ps1)**: Parses TSV clipboard data into objects.

### Command

- **[Get-CommandParameters.ps1](Get-CommandParameters.ps1)**: Returns the parameters of the specified cmdlet.
- **[Get-CommandPath.ps1](Get-CommandPath.ps1)**: Locates a command.
- **[Hide-Command.ps1](Hide-Command.ps1)**: Make a command unavailable.
- **[Invoke-CachedCommand.ps1](Invoke-CachedCommand.ps1)**: Caches the output of a command for recall if called again.
- **[Invoke-CommandWithParams.ps1](Invoke-CommandWithParams.ps1)**: Execute a command by using matching dictionary entries as parameters.
- **[Use-Command.ps1](Use-Command.ps1)**: Checks for the existence of the given command, and adds if missing and a source is defined.

### Configuration

- **[Get-ConfigConnectionStringBuilders.ps1](Get-ConfigConnectionStringBuilders.ps1)**: Return named connection string builders for connection strings in a config file.
- **[Get-NuGetConfigs.ps1](Get-NuGetConfigs.ps1)**: Returns the available NuGet configuration files, in order of preference.
- **[Use-NetMailConfig.ps1](Use-NetMailConfig.ps1)**: Use .NET configuration to set defaults for Send-MailMessage.

### Console

- **[Disable-AnsiColor.ps1](Disable-AnsiColor.ps1)**: Disables ANSI terminal colors.
- **[Enable-AnsiColor.ps1](Enable-AnsiColor.ps1)**: Enables ANSI terminal colors.
- **[Get-ConsoleHistory.ps1](Get-ConsoleHistory.ps1)**: Returns the DOSKey-style console command history (up arrow or F8).
- **[Remove-ConsoleHistory.ps1](Remove-ConsoleHistory.ps1)**: Removes an entry from the DOSKey-style console command history (up arrow or F8).
- **[Set-ConsoleColorTheme.ps1](Set-ConsoleColorTheme.ps1)**: Overrides ConsoleClass window color palette entries with a preset color theme.

### Credential

- **[Export-SecretVault.ps1](Export-SecretVault.ps1)**: Exports secret vault content.
- **[Get-CachedCredential.ps1](Get-CachedCredential.ps1)**: Return a credential from secure storage, or prompt the user for it if not found.
- **[Get-SecretDetails.ps1](Get-SecretDetails.ps1)**: Returns secret info from the secret vaults, including metadata as properties.
- **[Import-SecretVault.ps1](Import-SecretVault.ps1)**: Imports secrets into secret vaults.
- **[Remove-CachedCredential.ps1](Remove-CachedCredential.ps1)**: Removes a credential from secure storage.
- **[Save-Secret.ps1](Save-Secret.ps1)**: Sets a secret in a secret vault with metadata.

### Data

- **[Limit-Digits.ps1](Limit-Digits.ps1)**: Rounds off a number to the requested number of digits.
- **[Measure-Properties.ps1](Measure-Properties.ps1)**: Provides frequency details about the properties across objects in the pipeline.
- **[Measure-Values.ps1](Measure-Values.ps1)**: Provides analysis of supplied values.

### Data encoding

- **[ConvertFrom-Base64.ps1](ConvertFrom-Base64.ps1)**: Converts base64-encoded text to bytes or text.
- **[ConvertFrom-Hex.ps1](ConvertFrom-Hex.ps1)**: Convert a string of hexadecimal digits into a byte array.
- **[ConvertTo-Base64.ps1](ConvertTo-Base64.ps1)**: Converts bytes or text to base64-encoded text.

### Data formats

- **[ConvertTo-PowerShell.ps1](ConvertTo-PowerShell.ps1)**: Serializes complex content into PowerShell literals.
- **[Format-EscapedUrl.ps1](Format-EscapedUrl.ps1)**: Escape URLs more aggressively.
- **[New-Jwt.ps1](New-Jwt.ps1)**: Generates a JSON Web Token (JWT)
- **[Split-Uri.ps1](Split-Uri.ps1)**: Splits a URI into component parts.
- **[Test-FileTypeMagicNumber.ps1](Test-FileTypeMagicNumber.ps1)**: Tests for a given common file type by magic number.
- **[Test-Jwt.ps1](Test-Jwt.ps1)**: Determines whether a string is a valid JWT.
- **[Test-MagicNumber.ps1](Test-MagicNumber.ps1)**: Tests a file for a "magic number" (identifying sequence of bytes) at a given location.
- **[Test-Uri.ps1](Test-Uri.ps1)**: Determines whether a string is a valid URI.
- **[Test-Windows1252.ps1](Test-Windows1252.ps1)**: Determines whether a file contains Windows-1252 bytes that are invalid UTF-8 bytes.

### Database

- **[ConvertFrom-DataRow.ps1](ConvertFrom-DataRow.ps1)**: Converts a DataRow object to a PSObject, Hashtable, or single value.
- **[Export-DatabaseScripts.ps1](Export-DatabaseScripts.ps1)**: Exports MS SQL database objects from the given server and database as files, into a consistent folder structure.
- **[Export-TableMerge.ps1](Export-TableMerge.ps1)**: Exports table data as a T-SQL MERGE statement.
- **[Find-DatabaseValue.ps1](Find-DatabaseValue.ps1)**: Searches an entire database for a field value.
- **[Find-DbColumn.ps1](Find-DbColumn.ps1)**: Searches for database columns.
- **[Find-DbIndexes.ps1](Find-DbIndexes.ps1)**: Returns indexes using a column with the given name.
- **[Initialize-DatabaseNotebook.ps1](Initialize-DatabaseNotebook.ps1)**: Populates a new notebook with details about a database.
- **[Measure-DbColumn.ps1](Measure-DbColumn.ps1)**: Provides statistics about SQL Server column data.
- **[Measure-DbColumnValues.ps1](Measure-DbColumnValues.ps1)**: Provides sorted counts of SQL Server column values.
- **[Measure-DbTable.ps1](Measure-DbTable.ps1)**: Provides frequency details about SQL Server table data.
- **[New-DbProviderObject.ps1](New-DbProviderObject.ps1)**: Create a common database object.
- **[Repair-DatabaseConstraintNames.ps1](Repair-DatabaseConstraintNames.ps1)**: Finds database constraints with system-generated names and gives them deterministic names.
- **[Repair-DatabaseUntrustedConstraints.ps1](Repair-DatabaseUntrustedConstraints.ps1)**: Finds database constraints that have been incompletely re-enabled.
- **[Send-SqlReport.ps1](Send-SqlReport.ps1)**: Execute a SQL statement and email the results.
- **[Test-ConnectionString.ps1](Test-ConnectionString.ps1)**: Test a given connection string and provide details about the connection.
- **[Use-SqlcmdParams.ps1](Use-SqlcmdParams.ps1)**: Use the calling script parameters to set Invoke-Sqlcmd defaults.

### Date and time

- **[Add-TimeSpan.ps1](Add-TimeSpan.ps1)**: Adds a timespan to DateTime values.
- **[ConvertFrom-Duration.ps1](ConvertFrom-Duration.ps1)**: Parses a Timespan from a ISO8601 duration string.
- **[ConvertFrom-EpochTime.ps1](ConvertFrom-EpochTime.ps1)**: Converts an integer Unix (POSIX) time (seconds since Jan 1, 1970) into a DateTime value.
- **[ConvertFrom-IsoWeekDate.ps1](ConvertFrom-IsoWeekDate.ps1)**: Returns a DateTime object from an ISO week date string.
- **[ConvertTo-EpochTime.ps1](ConvertTo-EpochTime.ps1)**: Converts a DateTime value into an integer Unix (POSIX) time, seconds since Jan 1, 1970.
- **[ConvertTo-LogParserTimestamp.ps1](ConvertTo-LogParserTimestamp.ps1)**: Formats a datetime as a LogParser literal.
- **[Format-Date.ps1](Format-Date.ps1)**: Returns a date/time as a named format.
- **[Get-FrenchRepublicanDate.ps1](Get-FrenchRepublicanDate.ps1)**: Returns a date and time converted to the French Republican Calendar.
- **[Show-Time.ps1](Show-Time.ps1)**: Displays a formatted date using powerline font characters.
- **[Test-DateTime.ps1](Test-DateTime.ps1)**: Tests whether the given string can be parsed as a date.
- **[Test-USFederalHoliday.ps1](Test-USFederalHoliday.ps1)**: Returns true if the given date is a U.S. federal holiday.

### Dictionary

- **[Compare-Keys.ps1](Compare-Keys.ps1)**: Returns the differences between two dictionaries.
- **[ConvertTo-OrderedDictionary.ps1](ConvertTo-OrderedDictionary.ps1)**: Converts an object to an ordered dictionary of properties and values.
- **[Join-Keys.ps1](Join-Keys.ps1)**: Combines dictionaries together into a single dictionary.
- **[Remove-NullValues.ps1](Remove-NullValues.ps1)**: Removes dictionary entries with null vaules.
- **[Split-Keys.ps1](Split-Keys.ps1)**: Clones a dictionary keeping only the specified keys.

### DotNet

- **[Find-DotNetTools.ps1](Find-DotNetTools.ps1)**: Returns a list of matching dotnet tools.
- **[Get-AssemblyFramework.ps1](Get-AssemblyFramework.ps1)**: Gets the framework version an assembly was compiled for.
- **[Get-DotNetFrameworkVersions.ps1](Get-DotNetFrameworkVersions.ps1)**: Determine which .NET Frameworks are installed on the requested system.
- **[Get-DotNetGlobalTools.ps1](Get-DotNetGlobalTools.ps1)**: Returns a list of global dotnet tools.
- **[Get-DotNetVersions.ps1](Get-DotNetVersions.ps1)**: Determine which .NET Core & Framework versions are installed.
- **[Update-DotNetPackages.ps1](Update-DotNetPackages.ps1)**: Updates NuGet packages for a .NET solution or project.

### EnvironmentVariables

- **[Compress-EnvironmentVariables.ps1](Compress-EnvironmentVariables.ps1)**: Replaces each of the longest matching parts of a string with an embedded environment variable with that value.
- **[Expand-EnvironmentVariables.ps1](Expand-EnvironmentVariables.ps1)**: Replaces the name of each environment variable embedded in the specified string with the string equivalent of the value of the variable, then returns the resulting string.

### Files

- **[Backup-File.ps1](Backup-File.ps1)**: Create a backup as a sibling to a file, with date and time values in the name.
- **[Find-NewestFile.ps1](Find-NewestFile.ps1)**: Finds the most recent file.
- **[Join-FileName.ps1](Join-FileName.ps1)**: Combines a filename with a string.
- **[Measure-Caches.ps1](Measure-Caches.ps1)**: Returns a list of matching cache directories, and their sizes, sorted.
- **[New-Shortcut.ps1](New-Shortcut.ps1)**: Create a Windows shortcut.
- **[Remove-LockyFile.ps1](Remove-LockyFile.ps1)**: Removes a file that may be prone to locking.
- **[Show-PSDriveUsage.ps1](Show-PSDriveUsage.ps1)**: Displays drive usage graphically, and with a human-readable summary.
- **[Test-LockedFile.ps1](Test-LockedFile.ps1)**: Returns true if the specified file is locked.
- **[Test-NewerFile.ps1](Test-NewerFile.ps1)**: Returns true if the difference file is newer than the reference file.
- **[Update-Files.ps1](Update-Files.ps1)**: Copies specified source files that exist in the destination directory.

### Git and GitHub

- **[Add-GitHubMetadata.ps1](Add-GitHubMetadata.ps1)**: Adds GitHub Linguist overrides to a repo's .gitattributes.
- **[Copy-GitHubLabels.ps1](Copy-GitHubLabels.ps1)**: Copies configured issue labels from one repo to another.
- **[Get-GitFileMetadata.ps1](Get-GitFileMetadata.ps1)**: Returns the creation and last modification metadata for a file in a git repo.
- **[Get-GitFirstCommit.ps1](Get-GitFirstCommit.ps1)**: Gets the SHA-1 hash of the first commit of the current repo.
- **[Get-RepoName.ps1](Get-RepoName.ps1)**: Gets the name of the repo.
- **[Rename-GitHubLocalBranch.ps1](Rename-GitHubLocalBranch.ps1)**: Rename a git repository branch.
- **[Trace-GitRepoTest.ps1](Trace-GitRepoTest.ps1)**: Uses git bisect to search for the point in the repo history that the test script starts returning true.

### HTTP

- **[ConvertTo-BasicAuthentication.ps1](ConvertTo-BasicAuthentication.ps1)**: Produces a basic authentication header string from a credential.
- **[ConvertTo-MultipartFormData.ps1](ConvertTo-MultipartFormData.ps1)**: Creates multipart/form-data to send as a request body.
- **[Get-ContentSecurityPolicy.ps1](Get-ContentSecurityPolicy.ps1)**: Returns the content security policy at from the given URL.
- **[Get-SslDetails.ps1](Get-SslDetails.ps1)**: Enumerates the SSL protocols that the client is able to successfully use to connect to a server.
- **[Save-WebRequest.ps1](Save-WebRequest.ps1)**: Downloads a given URL to a file, automatically determining the filename.
- **[Show-HttpStatus.ps1](Show-HttpStatus.ps1)**: Displays the HTTP status code info.
- **[Trace-WebRequest.ps1](Trace-WebRequest.ps1)**: Provides details about a retrieving a URI.

### Json

- **[Export-Json.ps1](Export-Json.ps1)**: Exports a portion of a JSON document, recursively importing references.
- **[Export-OpenApiSchema.ps1](Export-OpenApiSchema.ps1)**: Extracts a JSON schema from an OpenAPI definition.
- **[Get-OpenApiInfo.ps1](Get-OpenApiInfo.ps1)**: Returns metadata from an OpenAPI definition.
- **[Merge-Json.ps1](Merge-Json.ps1)**: Create a new JSON string by recursively combining the properties of JSON strings.
- **[Resolve-JsonPointer.ps1](Resolve-JsonPointer.ps1)**: Returns matching JSON Pointer paths, given a JSON Pointer path with wildcards.
- **[Select-Json.ps1](Select-Json.ps1)**: Returns a value from a JSON string or file.
- **[Set-Json.ps1](Set-Json.ps1)**: Sets a property in a JSON string or file.
- **[Show-OpenApiInfo.ps1](Show-OpenApiInfo.ps1)**: Displays metadata from an OpenAPI definition.

### Markdown

- **[Repair-MarkdownHeaders.ps1](Repair-MarkdownHeaders.ps1)**: Updates markdown content to replace level 1 & 2 ATX headers to Setext headers.

### Mermaid Diagrams

- **[Export-MermaidER.ps1](Export-MermaidER.ps1)**: Generates a Mermaid entity relation diagram for database tables.
- **[Export-MermaidXY.ps1](Export-MermaidXY.ps1)**: Generates a Mermaid XY bar/line chart for the values of a series of properties.

### Notebooks

- **[Add-NotebookCell.ps1](Add-NotebookCell.ps1)**: When run within a Polyglot Notebook, appends a cell to it.

### Packages and libraries

- **[Find-ProjectPackages.ps1](Find-ProjectPackages.ps1)**: Find modules used in projects.
- **[Get-LibraryVulnerabilityInfo.ps1](Get-LibraryVulnerabilityInfo.ps1)**: Get the list of module/package/library vulnerabilities from the RetireJS or SafeNuGet projects.

### Parameters

- **[Add-ParameterDefault.ps1](Add-ParameterDefault.ps1)**: Appends or creates a value to use for the specified cmdlet parameter to use when one is not specified.
- **[Remove-ParameterDefault.ps1](Remove-ParameterDefault.ps1)**: Removes a value that would have been used for a parameter if none was specified, if one existed.
- **[Set-ParameterDefault.ps1](Set-ParameterDefault.ps1)**: Assigns a value to use for the specified cmdlet parameter to use when one is not specified.

### PowerShell

- **[Add-Counter.ps1](Add-Counter.ps1)**: Adds an incrementing integer property to each pipeline object.
- **[Add-DynamicParam.ps1](Add-DynamicParam.ps1)**: Adds a dynamic parameter to a script, within a DynamicParam block.
- :up: **[Add-NugetPackage.ps1](Add-NugetPackage.ps1)**: Loads a NuGet package DLL, downloading as needed.
- **[Add-ScopeLevel.ps1](Add-ScopeLevel.ps1)**: Convert a scope level to account for another call stack level.
- **[ForEach-Progress.ps1](ForEach-Progress.ps1)**: Performs an operation against each item in a collection of input objects, with a progress bar.
- **[Format-ByteUnits.ps1](Format-ByteUnits.ps1)**: Converts bytes to largest possible units, to improve readability.
- **[Format-Permutations.ps1](Format-Permutations.ps1)**: Builds format strings using every combination of elements from multiple arrays.
- **[Get-EnumValues.ps1](Get-EnumValues.ps1)**: Returns the possible values of the specified enumeration.
- **[Get-TypeAccelerators.ps1](Get-TypeAccelerators.ps1)**: Returns the list of PowerShell type accelerators.
- **[Import-Variables.ps1](Import-Variables.ps1)**: Creates local variables from a data row or dictionary (hashtable).
- **[Invoke-WindowsPowerShell.ps1](Invoke-WindowsPowerShell.ps1)**: Runs commands in Windows PowerShell (typically from PowerShell Core).
- **[Merge-PSObject.ps1](Merge-PSObject.ps1)**: Create a new PSObject by recursively combining the properties of PSObjects.
- **[Read-Choice.ps1](Read-Choice.ps1)**: Returns choice selected from a list of options.
- **[Stop-ThrowError.ps1](Stop-ThrowError.ps1)**: Throws a better error than "throw".
- :up: **[Test-Administrator.ps1](Test-Administrator.ps1)**: Checks whether the current session has administrator privileges.
- **[Test-Interactive.ps1](Test-Interactive.ps1)**: Determines whether both the user and process are interactive.
- **[Test-Range.ps1](Test-Range.ps1)**: Returns true from an initial condition until a terminating condition; a latching test.
- **[Test-Variable.ps1](Test-Variable.ps1)**: Indicates whether a variable has been defined.
- **[Use-ProgressView.ps1](Use-ProgressView.ps1)**: Sets the progress bar display view.
- **[Use-ReasonableDefaults.ps1](Use-ReasonableDefaults.ps1)**: Sets certain cmdlet parameter defaults to rational, useful values.
- **[Write-Info.ps1](Write-Info.ps1)**: Writes to the information stream, with color support and more.

### PowerShell Modules

- **[Get-ModuleScope.ps1](Get-ModuleScope.ps1)**: Returns the scope of an installed module.
- **[Uninstall-OldModules.ps1](Uninstall-OldModules.ps1)**: Uninstalls old module versions.
- **[Update-Modules.ps1](Update-Modules.ps1)**: Cleans up old modules.

### Properties

- **[Add-NoteProperty.ps1](Add-NoteProperty.ps1)**: Adds a NoteProperty to a PSObject, calculating the value with the object in context.
- **[Compare-Properties.ps1](Compare-Properties.ps1)**: Compares the properties of two objects.
- **[Test-NoteProperty.ps1](Test-NoteProperty.ps1)**: Looks for any matching NoteProperties on an object.

### Scheduled Tasks

- **[Backup-SchTasks.ps1](Backup-SchTasks.ps1)**: Exports the local list of Scheduled Tasks into a single XML file.
- **[ConvertFrom-CimInstance.ps1](ConvertFrom-CimInstance.ps1)**: Convert a CimInstance object to a PSObject.
- **[ConvertTo-ICalendar.ps1](ConvertTo-ICalendar.ps1)**: Converts supported objects (Scheduled Tasks) to the RFC 5545 iCalendar format.
- **[Copy-SchTasks.ps1](Copy-SchTasks.ps1)**: Copy scheduled jobs from another computer to this one, using a GUI list to choose jobs.
- **[Get-SimpleSchTasks.ps1](Get-SimpleSchTasks.ps1)**: Returns simple scheduled task info.
- **[Restore-SchTasks.ps1](Restore-SchTasks.ps1)**: Imports from a single XML file into the local Scheduled Tasks.
- **[Set-SchTaskMsa.ps1](Set-SchTaskMsa.ps1)**: Sets a Scheduled Task's runtime user as the given gMSA/MSA.

### Scripts

- **[New-PesterTests.ps1](New-PesterTests.ps1)**: Creates a new Pester testing script from a script's examples and parameter sets.
- **[New-Script.ps1](New-Script.ps1)**: Creates a simple boilerplate script.
- **[Optimize-Help.ps1](Optimize-Help.ps1)**: Cleans up comment-based help blocks by fully unindenting and capitalizing dot keywords.
- **[Rename-Script.ps1](Rename-Script.ps1)**: Renames all instances of a script, and updates any usage of it.
- **[Repair-ScriptStyle.ps1](Repair-ScriptStyle.ps1)**: Accepts justifications for script analysis rule violations, fixing the rest using Invoke-ScriptAnalysis.
- **[Select-ScriptCommands.ps1](Select-ScriptCommands.ps1)**: Returns the commands used by the specified script.

### Search and replace

- **[Add-CapturesToMatches.ps1](Add-CapturesToMatches.ps1)**: Adds named capture group values as note properties to Select-String MatchInfo objects.
- **[Find-Lines.ps1](Find-Lines.ps1)**: Searches a specific subset of files for lines matching a pattern.
- **[Select-CapturesFromMatches.ps1](Select-CapturesFromMatches.ps1)**: Selects named capture group values as note properties from Select-String MatchInfo objects.
- **[Set-RegexReplace.ps1](Set-RegexReplace.ps1)**: Updates text found with Select-String, using a regular expression replacement template.

### Seq

- **[Send-SeqEvent.ps1](Send-SeqEvent.ps1)**: Send an event to a Seq server.
- **[Send-SeqScriptEvent.ps1](Send-SeqScriptEvent.ps1)**: Sends an event (often an error) from a script to a Seq server, including script info.
- **[Use-SeqServer.ps1](Use-SeqServer.ps1)**: Set the default Server and ApiKey for Send-SeqEvent.ps1

### System and updates

- **[Convert-ChocolateyToWinget.ps1](Convert-ChocolateyToWinget.ps1)**: Change from managing various packages with Chocolatey to WinGet.
- **[Export-EdgeKeywords.ps1](Export-EdgeKeywords.ps1)**: Returns the configured search keywords from an Edge SQLite file.
- **[Export-InstalledPackages.ps1](Export-InstalledPackages.ps1)**: Exports the list of packages installed by various tools.
- **[Find-InstalledPrograms.ps1](Find-InstalledPrograms.ps1)**: Searches installed programs.
- **[Get-SystemDetails.ps1](Get-SystemDetails.ps1)**: Collects some useful system hardware and operating system details via CIM.
- **[Import-EdgeKeywords.ps1](Import-EdgeKeywords.ps1)**: Adds search keywords to an Edge SQLite profile configuration.
- **[Read-ChocolateySummary.ps1](Read-ChocolateySummary.ps1)**: Retrieves the a summary from the Chocolatey log.
- :new: **[Show-Status.ps1](Show-Status.ps1)**: Displays requested system status values using powerline font characters.
- :up: **[Update-Everything.ps1](Update-Everything.ps1)**: Updates everything it can on the system.
- **[Use-Java.ps1](Use-Java.ps1)**: Switch the Java version for the current process by modifying environment variables.

### TLS/SSL

- **[Get-ServerCertificate.ps1](Get-ServerCertificate.ps1)**: Returns the certificate provided by the requested server.

### Unicode

- **[ConvertTo-FileName.ps1](ConvertTo-FileName.ps1)**: Returns a valid and safe filename from a given string.
- **[ConvertTo-SafeEntities.ps1](ConvertTo-SafeEntities.ps1)**: Encode text as XML/HTML, escaping all characters outside 7-bit ASCII.
- **[Get-CharacterDetails.ps1](Get-CharacterDetails.ps1)**: Returns filterable categorical information about characters in the Unicode Basic Multilingual Plane.
- **[Get-Unicode.ps1](Get-Unicode.ps1)**: Returns the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.
- **[Get-UnicodeByName.ps1](Get-UnicodeByName.ps1)**: Returns characters based on Unicode code point name, GitHub short code, or HTML entity.
- **[Get-UnicodeData.ps1](Get-UnicodeData.ps1)**: Returns the current (cached) Unicode character data.
- **[Get-UnicodeName.ps1](Get-UnicodeName.ps1)**: Returns the name of a Unicode code point.
- :up: **[Import-CharConstants.ps1](Import-CharConstants.ps1)**: Imports characters by name as constants into the current scope.

### VSCode

- **[Add-VsCodeDatabaseConnection.ps1](Add-VsCodeDatabaseConnection.ps1)**: Adds a VS Code MSSQL database connection to the repo.
- **[Get-VSCCurrentFile.ps1](Get-VSCCurrentFile.ps1)**: Returns the path of the current file open in VSCode, when run in the PowerShell Extension Terminal in VSCode.
- **[Get-VSCodeSetting.ps1](Get-VSCodeSetting.ps1)**: Sets a VSCode setting.
- **[Get-VSCodeSettingsFile.ps1](Get-VSCodeSettingsFile.ps1)**: Gets the path of the VSCode settings.config file.
- **[Import-VsCodeDatabaseConnections.ps1](Import-VsCodeDatabaseConnections.ps1)**: Adds config XDT connection strings to VSCode settings.
- **[Push-WorkspaceLocation.ps1](Push-WorkspaceLocation.ps1)**: Pushes the current VS Code editor workspace location to the location stack.
- **[Set-VSCodeSetting.ps1](Set-VSCodeSetting.ps1)**: Sets a VSCode setting.

### XML

- **[Compare-Xml.ps1](Compare-Xml.ps1)**: Compares two XML documents and returns the differences.
- **[Convert-Xml.ps1](Convert-Xml.ps1)**: Transform XML using an XSLT template.
- **[ConvertFrom-EscapedXml.ps1](ConvertFrom-EscapedXml.ps1)**: Parse escaped XML into XML and serialize it.
- **[ConvertFrom-XmlElement.ps1](ConvertFrom-XmlElement.ps1)**: Converts named nodes of an element to properties of a PSObject, recursively.
- **[ConvertTo-XmlElements.ps1](ConvertTo-XmlElements.ps1)**: Serializes complex content into XML elements.
- **[Format-Xml.ps1](Format-Xml.ps1)**: Pretty-print XML.
- **[Get-XmlNamespaces.ps1](Get-XmlNamespaces.ps1)**: Gets the namespaces from a document as a dictionary.
- **[Merge-XmlSelections.ps1](Merge-XmlSelections.ps1)**: Builds an object using the named XPath selections as properties.
- **[New-NamespaceManager.ps1](New-NamespaceManager.ps1)**: Creates an object to lookup XML namespace prefixes.
- **[Resolve-XmlSchemaLocation.ps1](Resolve-XmlSchemaLocation.ps1)**: Gets the namespaces and their URIs and URLs from a document.
- **[Resolve-XPath.ps1](Resolve-XPath.ps1)**: Returns the XPath of the location of an XML node.
- **[Show-DataRef.ps1](Show-DataRef.ps1)**: Display an HTML view of an XML schema or WSDL using Saxon.
- **[Test-Xml.ps1](Test-Xml.ps1)**: Try parsing text as XML, and validating it if a schema is provided.

### Other

- **[Backup-Workstation.ps1](Backup-Workstation.ps1)**: Adds various configuration files and exported settings to a ZIP file.
- **[Connect-SshKey.ps1](Connect-SshKey.ps1)**: Uses OpenSSH to generate a key and connect it to an ssh server.
- **[ConvertTo-RomanNumeral.ps1](ConvertTo-RomanNumeral.ps1)**: Convert a number to a Roman numeral.
- **[Copy-Html.ps1](Copy-Html.ps1)**: Copies objects as an HTML table.
- :up: **[Export-Readme.ps1](Export-Readme.ps1)**: Generate README.md file for the scripts repo.
- **[Format-HtmlDataTable.ps1](Format-HtmlDataTable.ps1)**: Right-aligns numeric data in an HTML table for emailing, and optionally zebra-stripes &c.
- **[Get-ADServiceAccountInfo.ps1](Get-ADServiceAccountInfo.ps1)**: Lists the Global Managed Service Accounts for the domain, including the computers they are bound to.
- **[Get-AspNetEvents.ps1](Get-AspNetEvents.ps1)**: Parses ASP.NET errors from the event log on the given server.
- **[Get-Dns.ps1](Get-Dns.ps1)**: Looks up DNS info, given a hostname or address.
- **[Get-GitHubRepoChildItem.ps1](Get-GitHubRepoChildItem.ps1)**: Gets the items and child items in one or more specified locations.
- **[Get-IisLog.ps1](Get-IisLog.ps1)**: Easily query IIS logs.
- **[Get-PathUsage.ps1](Get-PathUsage.ps1)**: Returns the list of directories in the path, and the commands found in each.
- **[Get-PocketArticles.ps1](Get-PocketArticles.ps1)**: Retrieves a list of saved articles from a Pocket account.
- **[Get-RandomBytes.ps1](Get-RandomBytes.ps1)**: Returns random bytes.
- **[Get-Todos.ps1](Get-Todos.ps1)**: Returns the TODOs for the current git repo, which can help document technical debt.
- **[Measure-Indents.ps1](Measure-Indents.ps1)**: Measures the indentation characters used in a text file.
- **[Measure-StandardDeviation.ps1](Measure-StandardDeviation.ps1)**: Calculate the standard deviation of numeric values.
- **[Measure-TextFile.ps1](Measure-TextFile.ps1)**: Counts each type of indent and line ending.
- **[New-RandomVehicle.ps1](New-RandomVehicle.ps1)**: Generates random vehicle details with a valid VIN.
- **[Optimize-Path.ps1](Optimize-Path.ps1)**: Sorts, prunes, and normalizes both user and system Path entries.
- **[Remove-PocketArticle.ps1](Remove-PocketArticle.ps1)**: Removes an article from a Pocket account.
- **[Repair-AppxPackages.ps1](Repair-AppxPackages.ps1)**: Re-registers all installed Appx packages.
- **[Restore-Workstation.ps1](Restore-Workstation.ps1)**: Restores various configuration files and exported settings from a ZIP file.
- **[Save-PodcastEpisodes.ps1](Save-PodcastEpisodes.ps1)**: Downloads enclosures from a podcast feed.
- **[Send-MailMessageFile.ps1](Send-MailMessageFile.ps1)**: Sends emails from a drop folder using .NET config defaults.
- **[Test-HttpSecurity.ps1](Test-HttpSecurity.ps1)**: Scan sites using Mozilla's Observatory.
- :up: **[Write-CallInfo.ps1](Write-CallInfo.ps1)**: Prints caller name and parameters to the host for debugging purposes.
- **[Write-VisibleString.ps1](Write-VisibleString.ps1)**: Displays a string, showing nonprintable characters.

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

<!-- generated 08/29/2025 21:45:51 -->
