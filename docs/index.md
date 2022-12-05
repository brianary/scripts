[![Pester tests status](https://github.com/brianary/scripts/actions/workflows/pester.yml/badge.svg)][pester.yml]
[![Pester tests results](https://gist.githubusercontent.com/brianary/4642e5c804aa1b40738def5a7c03607a/raw/badge.svg)][pester.yml]
[![GitHub license badge](https://badgen.net/github/license/brianary/Scripts)](https://mit-license.org/ "MIT License")
[![GitHub stars badge](https://badgen.net/github/stars/brianary/Scripts)](https://github.com/brianary/scripts/stargazers "Stars")
[![GitHub watchers badge](https://badgen.net/github/watchers/brianary/Scripts)](https://github.com/brianary/scripts/watchers "Watchers")
[![GitHub forks badge](https://badgen.net/github/forks/brianary/Scripts)](https://github.com/brianary/scripts/network/members "Forks")
[![GitHub issues badge](https://badgen.net/github/open-issues/brianary/Scripts)](https://github.com/brianary/scripts/issues "Issues")
[![GitHub commits badge](https://badgen.net/github/commits/brianary/Scripts/main)](https://github.com/brianary/scripts/commits/main "Commits")
[![GitHub last commit badge](https://badgen.net/github/last-commit/brianary/Scripts/main)](https://github.com/brianary/scripts/commits/main "Last commit")
[![Mastodon: @brianary@mastodon.spotek.io](https://badgen.net/mastodon/follow/brianary@mastodon.spotek.io)](https://mastodon.spotek.io/@brianary "Mastodon profile")

[pester.yml]: https://github.com/brianary/scripts/actions/workflows/pester.yml "Pester test run history"

Scripts from the [Scripts](https://github.com/brianary/Scripts/) repo.


### Clipboard

- &#x1F199; **[Convert-ClipboardTsvToHtml.ps1](Convert-ClipboardTsvToHtml.ps1.md)**: Parses TSV clipboard data into HTML table data which is copied back to the clipboard.
- &#x1F199; **[Import-ClipboardTsv.ps1](Import-ClipboardTsv.ps1.md)**: Parses TSV clipboard data into objects.

### Comics

- &#x1F199; **[Find-Comics.ps1](Find-Comics.ps1.md)**: Finds comics.
- &#x1F199; **[Get-Comics.ps1](Get-Comics.ps1.md)**: Returns a cached list of comics from the Shortboxed API.
- &#x1F199; **[Open-Comic.ps1](Open-Comic.ps1.md)**: Opens a comic's PreviewsWorld page.

### Command

- &#x1F199; **[Get-CommandParameters.ps1](Get-CommandParameters.ps1.md)**: Returns the parameters of the specified cmdlet.
- &#x1F199; **[Get-CommandPath.ps1](Get-CommandPath.ps1.md)**: Locates a command.
- &#x1F199; **[Hide-Command.ps1](Hide-Command.ps1.md)**: Make a command unavailable.
- &#x1F199; **[Invoke-CommandWithParams.ps1](Invoke-CommandWithParams.ps1.md)**: Execute a command by using matching dictionary entries as parameters.
- &#x1F199; **[Use-Command.ps1](Use-Command.ps1.md)**: Checks for the existence of the given command, and adds if missing and a source is defined.

### Configuration

- &#x1F199; **[Get-ConfigConnectionStringBuilders.ps1](Get-ConfigConnectionStringBuilders.ps1.md)**: Return named connection string builders for connection strings in a config file.
- &#x1F199; **[Use-NetMailConfig.ps1](Use-NetMailConfig.ps1.md)**: Use .NET configuration to set defaults for Send-MailMessage.

### Console

- &#x1F199; **[Disable-AnsiColor.ps1](Disable-AnsiColor.ps1.md)**: Disables ANSI terminal colors.
- &#x1F199; **[Enable-AnsiColor.ps1](Enable-AnsiColor.ps1.md)**: Enables ANSI terminal colors.
- &#x1F199; **[Get-ConsoleHistory.ps1](Get-ConsoleHistory.ps1.md)**: Returns the DOSKey-style console command history (up arrow or F8).
- &#x1F199; **[Set-ConsoleColorTheme.ps1](Set-ConsoleColorTheme.ps1.md)**: Overrides ConsoleClass window color palette entries with a preset color theme.

### Credential

- &#x1F199; **[Get-CachedCredential.ps1](Get-CachedCredential.ps1.md)**: Return a credential from secure storage, or prompt the user for it if not found.
- &#x1F199; **[Remove-CachedCredential.ps1](Remove-CachedCredential.ps1.md)**: Removes a credential from secure storage.

### Data encoding

- &#x1F199; **[ConvertFrom-Base64.ps1](ConvertFrom-Base64.ps1.md)**: Converts base64-encoded text to bytes or text.
- &#x1F199; **[ConvertFrom-Hex.ps1](ConvertFrom-Hex.ps1.md)**: Convert a string of hexadecimal digits into a byte array.
- &#x1F199; **[ConvertTo-Base64.ps1](ConvertTo-Base64.ps1.md)**: Converts bytes or text to base64-encoded text.

### Data formats

- &#x1F199; **[ConvertTo-PowerShell.ps1](ConvertTo-PowerShell.ps1.md)**: Serializes complex content into PowerShell literals.
- &#x1F199; **[Format-EscapedUrl.ps1](Format-EscapedUrl.ps1.md)**: Escape URLs more aggressively.
- &#x1F199; **[New-Jwt.ps1](New-Jwt.ps1.md)**: Generates a JSON Web Token (JWT)
- &#x1F199; **[Test-FileTypeMagicNumber.ps1](Test-FileTypeMagicNumber.ps1.md)**: Tests for a given common file type by magic number.
- &#x1F199; **[Test-Jwt.ps1](Test-Jwt.ps1.md)**: Determines whether a string is a valid JWT.
- &#x1F199; **[Test-MagicNumber.ps1](Test-MagicNumber.ps1.md)**: Tests a file for a "magic number" (identifying sequence of bytes) at a given location.
- &#x1F199; **[Test-Uri.ps1](Test-Uri.ps1.md)**: Determines whether a string is a valid URI.
- &#x1F199; **[Test-Windows1252.ps1](Test-Windows1252.ps1.md)**: Determines whether a file contains Windows-1252 bytes that are invalid UTF-8 bytes.

### Database

- &#x1F199; **[ConvertFrom-DataRow.ps1](ConvertFrom-DataRow.ps1.md)**: Converts a DataRow object to a PSObject, Hashtable, or single value.
- &#x1F199; **[Export-DatabaseObjectScript.ps1](Export-DatabaseObjectScript.ps1.md)**: Exports MS SQL script for an object from the given server.
- &#x1F199; **[Export-DatabaseScripts.ps1](Export-DatabaseScripts.ps1.md)**: Exports MS SQL database objects from the given server and database as files, into a consistent folder structure.
- &#x1F199; **[Export-TableMerge.ps1](Export-TableMerge.ps1.md)**: Exports table data as a T-SQL MERGE statement.
- &#x1F199; **[Find-DatabaseValue.ps1](Find-DatabaseValue.ps1.md)**: Searches an entire database for a field value.
- &#x1F199; **[Find-DbColumn.ps1](Find-DbColumn.ps1.md)**: Searches for database columns.
- &#x1F199; **[Find-Indexes.ps1](Find-Indexes.ps1.md)**: Returns indexes using a column with the given name.
- &#x1F199; **[Find-SqlDeprecatedLargeValueTypes.ps1](Find-SqlDeprecatedLargeValueTypes.ps1.md)**: Reports text, ntext, and image datatypes found in a given database.
- &#x1F199; **[Measure-DbColumn.ps1](Measure-DbColumn.ps1.md)**: Provides statistics about SQL Server column data.
- &#x1F199; **[Measure-DbColumnValues.ps1](Measure-DbColumnValues.ps1.md)**: Provides sorted counts of SQL Server column values.
- &#x1F199; **[Measure-DbTable.ps1](Measure-DbTable.ps1.md)**: Provides frequency details about SQL Server table data.
- &#x1F199; **[New-DbProviderObject.ps1](New-DbProviderObject.ps1.md)**: Create a common database object.
- &#x1F199; **[Repair-DatabaseConstraintNames.ps1](Repair-DatabaseConstraintNames.ps1.md)**: Finds database constraints with system-generated names and gives them deterministic names.
- &#x1F199; **[Repair-DatabaseUntrustedConstraints.ps1](Repair-DatabaseUntrustedConstraints.ps1.md)**: Finds database constraints that have been incompletely re-enabled.
- &#x1F199; **[Send-SqlReport.ps1](Send-SqlReport.ps1.md)**: Execute a SQL statement and email the results.
- &#x1F199; **[Use-SqlcmdParams.ps1](Use-SqlcmdParams.ps1.md)**: Use the calling script parameters to set Invoke-Sqlcmd defaults.

### Date and time

- &#x1F199; **[Add-TimeSpan.ps1](Add-TimeSpan.ps1.md)**: Adds a timespan to DateTime values.
- &#x1F199; **[ConvertFrom-Duration.ps1](ConvertFrom-Duration.ps1.md)**: Parses a Timespan from a ISO8601 duration string.
- &#x1F199; **[ConvertTo-EpochTime.ps1](ConvertTo-EpochTime.ps1.md)**: Converts a DateTime value into an integer Unix (POSIX) time, seconds since Jan 1, 1970.
- &#x1F199; **[ConvertTo-LogParserTimestamp.ps1](ConvertTo-LogParserTimestamp.ps1.md)**: Formats a datetime as a LogParser literal.
- &#x1F199; **[Format-Date.ps1](Format-Date.ps1.md)**: Returns a date/time as a named format.
- &#x1F199; **[Get-FrenchRepublicanDate.ps1](Get-FrenchRepublicanDate.ps1.md)**: Returns a date and time converted to the French Republican Calendar.
- &#x1F199; **[Show-Time.ps1](Show-Time.ps1.md)**: Displays a formatted date using powerline font characters.
- &#x1F199; **[Test-DateTime.ps1](Test-DateTime.ps1.md)**: Tests whether the given string can be parsed as a date.
- &#x1F199; **[Test-USFederalHoliday.ps1](Test-USFederalHoliday.ps1.md)**: Returns true if the given date is a U.S. federal holiday.

### Dictionary

- &#x1F199; **[ConvertTo-OrderedDictionary.ps1](ConvertTo-OrderedDictionary.ps1.md)**: Converts an object to an ordered dictionary of properties and values.
- &#x1F199; **[Join-Keys.ps1](Join-Keys.ps1.md)**: Combines dictionaries together into a single dictionary.
- &#x1F199; **[Remove-NullValues.ps1](Remove-NullValues.ps1.md)**: Removes dictionary entries with null vaules.
- &#x1F199; **[Split-Keys.ps1](Split-Keys.ps1.md)**: Clones a dictionary keeping only the specified keys.

### DotNet

- &#x1F199; **[Find-DotNetGlobalTools.ps1](Find-DotNetGlobalTools.ps1.md)**: Returns a list of global dotnet tools.
- &#x1F199; **[Get-AssemblyFramework.ps1](Get-AssemblyFramework.ps1.md)**: Gets the framework version an assembly was compiled for.
- &#x1F199; **[Get-DotNetFrameworkVersions.ps1](Get-DotNetFrameworkVersions.ps1.md)**: Determine which .NET Frameworks are installed on the requested system.
- &#x1F199; **[Get-DotNetGlobalTools.ps1](Get-DotNetGlobalTools.ps1.md)**: Returns a list of global dotnet tools.
- &#x1F199; **[Get-DotNetVersions.ps1](Get-DotNetVersions.ps1.md)**: Determine which .NET Core & Framework versions are installed.

### EnvironmentVariables

- &#x1F199; **[Compress-EnvironmentVariables.ps1](Compress-EnvironmentVariables.ps1.md)**: Replaces each of the longest matching parts of a string with an embedded environment variable with that value.
- &#x1F199; **[Expand-EnvironmentVariables.ps1](Expand-EnvironmentVariables.ps1.md)**: Replaces the name of each environment variable embedded in the specified string with the string equivalent of the value of the variable, then returns the resulting string.

### Files

- &#x1F199; **[Backup-File.ps1](Backup-File.ps1.md)**: Create a backup as a sibling to a file, with date and time values in the name.
- &#x1F199; **[Find-DuplicateFiles.ps1](Find-DuplicateFiles.ps1.md)**: Removes duplicates from a list of files.
- &#x1F199; **[Find-NewestFile.ps1](Find-NewestFile.ps1.md)**: Finds the most recent file.
- &#x1F199; **[Join-FileName.ps1](Join-FileName.ps1.md)**: Combines a filename with a string.
- &#x1F199; **[New-Shortcut.ps1](New-Shortcut.ps1.md)**: Create a Windows shortcut.
- &#x1F199; **[Remove-LockyFile.ps1](Remove-LockyFile.ps1.md)**: Removes a file that may be prone to locking.
- &#x1F199; **[Split-FileName.ps1](Split-FileName.ps1.md)**: Returns the specified part of the filename.
- &#x1F199; **[Test-LockedFile.ps1](Test-LockedFile.ps1.md)**: Returns true if the specified file is locked.
- &#x1F199; **[Test-NewerFile.ps1](Test-NewerFile.ps1.md)**: Returns true if the difference file is newer than the reference file.
- &#x1F199; **[Update-Files.ps1](Update-Files.ps1.md)**: Copies specified source files that exist in the destination directory.

### Git and GitHub

- &#x1F199; **[Add-GitHubMetadata.ps1](Add-GitHubMetadata.ps1.md)**: Adds GitHub Linguist overrides to a repo's .gitattributes.
- &#x1F199; **[Get-GitFileMetadata.ps1](Get-GitFileMetadata.ps1.md)**: Returns the creation and last modification metadata for a file in a git repo.
- &#x1F199; **[Get-GitFirstCommit.ps1](Get-GitFirstCommit.ps1.md)**: Gets the SHA-1 hash of the first commit of the current repo.
- &#x1F199; **[Get-GitHubRepoChildItem.ps1](Get-GitHubRepoChildItem.ps1.md)**: Adds any missing topics based on repo content.
- &#x1F199; **[Get-RepoName.ps1](Get-RepoName.ps1.md)**: Gets the name of the repo.
- &#x1F199; **[Rename-GitHubLocalBranch.ps1](Rename-GitHubLocalBranch.ps1.md)**: Rename a git repository branch.
- &#x1F199; **[Trace-GitRepoTest.ps1](Trace-GitRepoTest.ps1.md)**: Uses git bisect to search for the point in the repo history that the test script starts returning true.

### HTTP

- &#x1F199; **[ConvertTo-BasicAuthentication.ps1](ConvertTo-BasicAuthentication.ps1.md)**: Produces a basic authentication header string from a credential.
- &#x1F199; **[ConvertTo-MultipartFormData.ps1](ConvertTo-MultipartFormData.ps1.md)**: Creates multipart/form-data to send as a request body.
- &#x1F199; **[Get-ContentSecurityPolicy.ps1](Get-ContentSecurityPolicy.ps1.md)**: Returns the content security policy at from the given URL.
- &#x1F199; **[Get-SslDetails.ps1](Get-SslDetails.ps1.md)**: Enumerates the SSL protocols that the client is able to successfully use to connect to a server.
- &#x1F199; **[Save-WebRequest.ps1](Save-WebRequest.ps1.md)**: Downloads a given URL to a file, automatically determining the filename.
- &#x1F199; **[Show-HttpStatus.ps1](Show-HttpStatus.ps1.md)**: Displays the HTTP status code info.

### Json

- &#x1F199; **[Merge-Json.ps1](Merge-Json.ps1.md)**: Create a new JSON string by recursively combining the properties of JSON strings.
- &#x1F199; **[Set-JsonProperty.ps1](Set-JsonProperty.ps1.md)**: Sets a property of arbitrary depth in a JSON string.
- &#x1F199; **[Test-Json.ps1](Test-Json.ps1.md)**: Determines whether a string is valid JSON.

### Packages and libraries

- &#x1F199; **[Find-ProjectPackages.ps1](Find-ProjectPackages.ps1.md)**: Find modules used in projects.
- &#x1F199; **[Get-LibraryVulnerabilityInfo.ps1](Get-LibraryVulnerabilityInfo.ps1.md)**: Get the list of module/package/library vulnerabilities from the RetireJS or SafeNuGet projects.

### Parameters

- &#x1F199; **[Add-ParameterDefault.ps1](Add-ParameterDefault.ps1.md)**: Appends or creates a value to use for the specified cmdlet parameter to use when one is not specified.
- &#x1F199; **[Remove-ParameterDefault.ps1](Remove-ParameterDefault.ps1.md)**: Removes a value that would have been used for a parameter if none was specified, if one existed.
- &#x1F199; **[Set-ParameterDefault.ps1](Set-ParameterDefault.ps1.md)**: Assigns a value to use for the specified cmdlet parameter to use when one is not specified.

### PowerShell

- &#x1F199; **[Add-Counter.ps1](Add-Counter.ps1.md)**: Adds an incrementing integer property to each pipeline object.
- &#x1F199; **[Add-DynamicParam.ps1](Add-DynamicParam.ps1.md)**: Adds a dynamic parameter to a script, within a DynamicParam block.
- &#x1F199; **[Add-ScopeLevel.ps1](Add-ScopeLevel.ps1.md)**: Convert a scope level to account for another call stack level.
- &#x1F199; **[ForEach-Progress.ps1](ForEach-Progress.ps1.md)**: Performs an operation against each item in a collection of input objects, with a progress bar.
- &#x1F199; **[Format-ByteUnits.ps1](Format-ByteUnits.ps1.md)**: Converts bytes to largest possible units, to improve readability.
- &#x1F199; **[Format-Permutations.ps1](Format-Permutations.ps1.md)**: Builds format strings using every combination of elements from multiple arrays.
- &#x1F199; **[Get-EnumValues.ps1](Get-EnumValues.ps1.md)**: Returns the possible values of the specified enumeration.
- &#x1F199; **[Get-TypeAccelerators.ps1](Get-TypeAccelerators.ps1.md)**: Returns the list of PowerShell type accelerators.
- &#x1F199; **[Import-Variables.ps1](Import-Variables.ps1.md)**: Creates local variables from a data row or dictionary (hashtable).
- &#x1F199; **[Invoke-WindowsPowerShell.ps1](Invoke-WindowsPowerShell.ps1.md)**: Runs commands in Windows PowerShell (typically from PowerShell Core).
- &#x1F199; **[Merge-PSObject.ps1](Merge-PSObject.ps1.md)**: Create a new PSObject by recursively combining the properties of PSObjects.
- &#x1F199; **[Read-Choice.ps1](Read-Choice.ps1.md)**: Returns choice selected from a list of options.
- &#x1F199; **[Stop-ThrowError.ps1](Stop-ThrowError.ps1.md)**: Throws a better error than "throw".
- &#x1F199; **[Test-Administrator.ps1](Test-Administrator.ps1.md)**: Checks whether the current session has administrator privileges.
- &#x1F199; **[Test-Interactive.ps1](Test-Interactive.ps1.md)**: Determines whether both the user and process are interactive.
- &#x1F199; **[Test-Range.ps1](Test-Range.ps1.md)**: Returns true from an initial condition until a terminating condition; a latching test.
- &#x1F199; **[Test-Variable.ps1](Test-Variable.ps1.md)**: Indicates whether a variable has been defined.
- &#x1F199; **[Use-ProgressView.ps1](Use-ProgressView.ps1.md)**: Sets the progress bar display view.
- &#x1F199; **[Use-ReasonableDefaults.ps1](Use-ReasonableDefaults.ps1.md)**: Sets certain cmdlet parameter defaults to rational, useful values.
- &#x1F199; **[Write-Info.ps1](Write-Info.ps1.md)**: Writes to the information stream, with color support and more.

### PowerShell Modules

- &#x1F199; **[Uninstall-OldModules.ps1](Uninstall-OldModules.ps1.md)**: Uninstalls old module versions.
- &#x1F199; **[Update-Modules.ps1](Update-Modules.ps1.md)**: Cleans up old modules.

### Properties

- &#x1F199; **[Add-NoteProperty.ps1](Add-NoteProperty.ps1.md)**: Adds a NoteProperty to a PSObject, calculating the value with the object in context.
- &#x1F199; **[Compare-Properties.ps1](Compare-Properties.ps1.md)**: Compares the properties of two objects.
- &#x1F199; **[Test-NoteProperty.ps1](Test-NoteProperty.ps1.md)**: Looks for any matching NoteProperties on an object.

### Scheduled Tasks

- &#x1F199; **[Backup-SchTasks.ps1](Backup-SchTasks.ps1.md)**: Exports the local list of Scheduled Tasks into a single XML file.
- &#x1F199; **[ConvertFrom-CimInstance.ps1](ConvertFrom-CimInstance.ps1.md)**: Convert a CimInstance object to a PSObject.
- &#x1F199; **[ConvertTo-ICalendar.ps1](ConvertTo-ICalendar.ps1.md)**: Converts supported objects to the RFC 5545 iCalendar format.
- &#x1F199; **[Copy-SchTasks.ps1](Copy-SchTasks.ps1.md)**: Copy scheduled jobs from another computer to this one, using a GUI list to choose jobs.
- &#x1F199; **[Restore-SchTasks.ps1](Restore-SchTasks.ps1.md)**: Imports from a single XML file into the local Scheduled Tasks.

### Scripts

- &#x1F199; **[New-PesterTests.ps1](New-PesterTests.ps1.md)**: Creates a new Pester testing script from a script's examples and parameter sets.
- &#x1F199; **[New-Script.ps1](New-Script.ps1.md)**: Creates a simple boilerplate script.
- &#x1F199; **[Optimize-Help.ps1](Optimize-Help.ps1.md)**: Cleans up comment-based help blocks by fully unindenting and capitalizing dot keywords.
- &#x1F199; **[Rename-Script.ps1](Rename-Script.ps1.md)**: Renames all instances of a script, and updates any usage of it.
- &#x1F199; **[Repair-ScriptStyle.ps1](Repair-ScriptStyle.ps1.md)**: Accepts justifications for script analysis rule violations, fixing the rest using Invoke-ScriptAnalysis.

### Search and replace

- &#x1F199; **[Add-CapturesToMatches.ps1](Add-CapturesToMatches.ps1.md)**: Adds named capture group values as note properties to Select-String MatchInfo objects.
- &#x1F199; **[Find-Lines.ps1](Find-Lines.ps1.md)**: Searches a specific subset of files for lines matching a pattern.
- &#x1F199; **[Select-CapturesFromMatches.ps1](Select-CapturesFromMatches.ps1.md)**: Selects named capture group values as note properties from Select-String MatchInfo objects.
- &#x1F199; **[Set-RegexReplace.ps1](Set-RegexReplace.ps1.md)**: Updates text found with Select-String, using a regular expression replacement template.

### Seq

- &#x1F199; **[Send-SeqEvent.ps1](Send-SeqEvent.ps1.md)**: Send an event to a Seq server.
- &#x1F199; **[Send-SeqScriptEvent.ps1](Send-SeqScriptEvent.ps1.md)**: Sends an event (often an error) from a script to a Seq server, including script info.
- &#x1F199; **[Use-SeqServer.ps1](Use-SeqServer.ps1.md)**: Set the default Server and ApiKey for Send-SeqEvent.ps1

### System and updates

- &#x1F199; **[Convert-ChocolateyToWinget.ps1](Convert-ChocolateyToWinget.ps1.md)**: Change from managing various packages with Chocolatey to WinGet.
- &#x1F199; **[Find-InstalledPrograms.ps1](Find-InstalledPrograms.ps1.md)**: Searches installed programs.
- &#x1F199; **[Get-SystemDetails.ps1](Get-SystemDetails.ps1.md)**: Collects some useful system hardware and operating system details via CIM.
- &#x1F199; **[Read-ChocolateySummary.ps1](Read-ChocolateySummary.ps1.md)**: Retrieves the a summary from the Chocolatey log.
- &#x1F199; **[Update-Everything.ps1](Update-Everything.ps1.md)**: Updates everything it can on the system.
- &#x1F199; **[Use-Java.ps1](Use-Java.ps1.md)**: Switch the Java version for the current process by modifying environment variables.

### Unicode

- &#x1F199; **[ConvertTo-SafeEntities.ps1](ConvertTo-SafeEntities.ps1.md)**: Encode text as XML/HTML, escaping all characters outside 7-bit ASCII.
- &#x1F199; **[Get-CharacterDetails.ps1](Get-CharacterDetails.ps1.md)**: Returns filterable categorical information about characters in the Unicode Basic Multilingual Plane.
- &#x1F199; **[Get-Unicode.ps1](Get-Unicode.ps1.md)**: Returns the (UTF-16) .NET string for a given Unicode codepoint, which may be a surrogate pair.
- &#x1F199; **[Get-UnicodeName.ps1](Get-UnicodeName.ps1.md)**: Returns the name of a Unicode code point.

### VSCode

- &#x1F199; **[Add-VsCodeDatabaseConnection.ps1](Add-VsCodeDatabaseConnection.ps1.md)**: Adds a VS Code MSSQL database connection to the repo.
- &#x1F199; **[Get-VSCodeSetting.ps1](Get-VSCodeSetting.ps1.md)**: Sets a VSCode setting.
- &#x1F199; **[Get-VSCodeSettingsFile.ps1](Get-VSCodeSettingsFile.ps1.md)**: Gets the path of the VSCode settings.config file.
- &#x1F199; **[Import-VsCodeDatabaseConnections.ps1](Import-VsCodeDatabaseConnections.ps1.md)**: Adds config XDT connection strings to VSCode settings.
- &#x1F199; **[Push-WorkspaceLocation.ps1](Push-WorkspaceLocation.ps1.md)**: Pushes the current VS Code editor workspace location to the location stack.
- &#x1F199; **[Set-VSCodeSetting.ps1](Set-VSCodeSetting.ps1.md)**: Sets a VSCode setting.

### XML

- &#x1F199; **[Compare-Xml.ps1](Compare-Xml.ps1.md)**: Compares two XML documents and returns the differences.
- &#x1F199; **[Convert-Xml.ps1](Convert-Xml.ps1.md)**: Transform XML using an XSLT template.
- &#x1F199; **[ConvertFrom-EscapedXml.ps1](ConvertFrom-EscapedXml.ps1.md)**: Parse escaped XML into XML and serialize it.
- &#x1F199; **[ConvertFrom-XmlElement.ps1](ConvertFrom-XmlElement.ps1.md)**: Converts named nodes of an element to properties of a PSObject, recursively.
- &#x1F199; **[ConvertTo-XmlElements.ps1](ConvertTo-XmlElements.ps1.md)**: Serializes complex content into XML elements.
- &#x1F199; **[Format-Xml.ps1](Format-Xml.ps1.md)**: Pretty-print XML.
- &#x1F199; **[Get-XmlNamespaces.ps1](Get-XmlNamespaces.ps1.md)**: Gets the namespaces from a document as a dictionary.
- &#x1F199; **[Merge-XmlSelections.ps1](Merge-XmlSelections.ps1.md)**: Builds an object using the named XPath selections as properties.
- &#x1F199; **[New-NamespaceManager.ps1](New-NamespaceManager.ps1.md)**: Creates an object to lookup XML namespace prefixes.
- &#x1F199; **[Resolve-XmlSchemaLocation.ps1](Resolve-XmlSchemaLocation.ps1.md)**: Gets the namespaces and their URIs and URLs from a document.
- &#x1F199; **[Resolve-XPath.ps1](Resolve-XPath.ps1.md)**: Returns the XPath of the location of an XML node.
- &#x1F199; **[Show-DataRef.ps1](Show-DataRef.ps1.md)**: Display an HTML view of an XML schema or WSDL using Saxon.
- &#x1F199; **[Test-Xml.ps1](Test-Xml.ps1.md)**: Try parsing text as XML, and validating it if a schema is provided.

### Other

- **[Connect-SshKey.ps1](Connect-SshKey.ps1.md)**: Uses OpenSSH to generate a key and connect it to an ssh server.
- **[ConvertTo-RomanNumeral.ps1](ConvertTo-RomanNumeral.ps1.md)**: Convert a number to a Roman numeral.
- **[Export-MermaidER.ps1](Export-MermaidER.ps1.md)**: Generates a Mermaid entity relation diagram for database tables.
- &#x1F199; **[Export-Readme.ps1](Export-Readme.ps1.md)**: Generate README.md file for the scripts repo.
- **[Format-HtmlDataTable.ps1](Format-HtmlDataTable.ps1.md)**: Right-aligns numeric data in an HTML table for emailing, and optionally zebra-stripes &c.
- **[Get-AspNetEvents.ps1](Get-AspNetEvents.ps1.md)**: Parses ASP.NET errors from the event log on the given server.
- **[Get-Dns.ps1](Get-Dns.ps1.md)**: Looks up DNS info, given a hostname or address.
- **[Get-IisLog.ps1](Get-IisLog.ps1.md)**: Easily query IIS logs.
- **[Get-PocketArticles.ps1](Get-PocketArticles.ps1.md)**: Retrieves a list of saved articles from a Pocket account.
- **[Get-RandomBytes.ps1](Get-RandomBytes.ps1.md)**: Returns random bytes.
- **[Get-Todos.ps1](Get-Todos.ps1.md)**: Returns the TODOs for the current git repo, which can help document technical debt.
- **[Measure-Indents.ps1](Measure-Indents.ps1.md)**: Measures the indentation characters used in a text file.
- **[Measure-StandardDeviation.ps1](Measure-StandardDeviation.ps1.md)**: Calculate the standard deviation of numeric values.
- **[Measure-TextFile.ps1](Measure-TextFile.ps1.md)**: Counts each type of indent and line ending.
- **[New-RandomVehicle.ps1](New-RandomVehicle.ps1.md)**: Generates random vehicle details with a valid VIN.
- **[Optimize-Path.ps1](Optimize-Path.ps1.md)**: Sorts, prunes, and normalizes both user and system Path entries.
- **[Save-PodcastEpisodes.ps1](Save-PodcastEpisodes.ps1.md)**: Saves enclosures from a podcast feed.
- **[Send-MailMessageFile.ps1](Send-MailMessageFile.ps1.md)**: Sends emails from a drop folder using .NET config defaults.
- **[Test-HttpSecurity.ps1](Test-HttpSecurity.ps1.md)**: Scan sites using Mozilla's Observatory.
- **[Write-VisibleString.ps1](Write-VisibleString.ps1.md)**: Displays a string, showing nonprintable characters.
