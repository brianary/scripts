Useful General-Purpose Scripts
==============================
This repo contains a collection of generally useful scripts (mostly Windows, mostly PowerShell).

PowerShell Scripts
------------------
- **Add-Xml.ps1**: Insert XML into an XML document relative to a node found by Select-Xml.
- **Backup-File.ps1**: Create a backup as a sibling to a file, with date and time values in the name.
- **ConvertFrom-DataRow.ps1**: Converts a DataRow object to a PSObject.
- **ConvertFrom-EscapedXml.ps1**: Parse escaped XML into XML and serialize it.
- **ConvertFrom-XmlElement.ps1**: Converts named nodes of an element to properties of a PSObject, recursively.
- **Copy-SchTasks.ps1**: Copy scheduled jobs from another computer to this one, using a GUI list to choose jobs.
- **Export-DatabaseObjectScript.ps1**: Exports MS SQL script for an object from the given server.
- **Export-DatabaseScripts.ps1**: Exports MS SQL database objects from the given server and database as files, into a consistent folder structure.
- **Export-Readme.ps1**: Generate README.md file for the scripts repo.
- **Export-TableMerge.ps1**: Exports table data as a T-SQL MERGE statement.
- **Find-Certificate.ps1**: Searches a certificate store for certificates.
- **Find-Lines.ps1**: Searches a specific subset of files for lines matching a pattern.
- **Find-NewestFile.ps1**: Finds the most recent file.
- **Find-ProjectPackages.ps1**: Find modules used in projects.
- **Find-SqlDeprecatedLargeValueTypes.ps1**: Reports text, ntext, and image datatypes found in a given database.
- **Format-ByteUnits.ps1**: Converts bytes to largest possible units, to improve readability.
- **Format-Xml.ps1**: Pretty-print XML.
- **Format-XmlElements.ps1**: Serializes complex content into XML elements.
- **Get-AspNetEvents.ps1**: Parses ASP.NET errors from the event log on the given server.
- **Get-CertificateExpiration.ps1**: Returns HTTPS certificate expiration and other cert info for a host.
- **Get-CertificatePath.ps1**: Gets the physical path on disk of a certificate.
- **Get-CertificatePermissions.ps1**: Returns the permissions of a certificate's private key file.
- **Get-CharacterDetails.ps1**: Returns filterable categorical information about a range of characters in the Unicode Basic Multilingual Plane.
- **Get-CommandPath.ps1**: Locates a command.
- **Get-ConfigConnectionStringBuilders.ps1**: Return named connection string builders for connection strings in a config file.
- **Get-EnumValues.ps1**: Returns the possible values of the specified enumeration.
- **Get-NetFrameworkVersions.ps1**: Determine which .NET Frameworks are installed on the requested system.
- **Get-SystemDetails.ps1**: Collects some useful system hardware and operating system details via WMI.
- **Grant-CertificateAccess.ps1**: Grants certificate file read access to an app pool or user.
- **Import-Variables.ps1**: Creates local variables from a data row or hashtable.
- **Install-ActiveDirectoryModule.ps1**: Installs the PowerShell ActiveDirectory module.
- **Install-SqlServerModule.ps1**: Installs SqlServer module and dependencies.
- **Measure-Indents.ps1**: Measures the indentation characters used in a text file.
- **New-DbProviderObject.ps1**: Create a common database object.
- **Optimize-Path.ps1**: Sorts, prunes, and normalizes both user and system Path entries.
- **Read-Choice.ps1**: Returns choice selected from a list of options.
- **Remove-LockyFile.ps1**: Removes a file that may be prone to locking.
- **Remove-Xml.ps1**: Removes a node found by Select-Xml from its XML document.
- **Repair-DatabaseConstraintNames.ps1**: Finds database constraints with system-generated names and gives them deterministic names.
- **Select-XmlNodeValue.ps1**: Returns the value of an XML node found by Select-Xml.
- **Send-SeqEvent.ps1**: Send an event to a Seq server.
- **Send-SeqScriptEvent.ps1**: Sends an event from a script to a Seq server, including script info.
- **Send-SqlReport.ps1**: Execute a SQL statement and email the results.
- **Set-XmlAttribute.ps1**: Adds an XML attribute to an XML element found by Select-Xml.
- **Set-XmlNodeValue.ps1**: Sets the value of a node found by Select-Xml.
- **Show-CertificatePermissions.ps1**: Shows the permissions of a certificate's private key file.
- **Test-Interactive.ps1**: Determines whether both the user and process are interactive.
- **Test-NewerFile.ps1**: Returns true if the difference file is newer than the reference file.
- **Test-Xml.ps1**: Try parsing text as XML.
- **Use-Command.ps1**: Checks for the existence of the given command, and adds if missing and a source is defined.
- **Use-NetMailConfig.ps1**: Use .NET configuration to set defaults for Send-MailMessage.
- **Use-SeqServer.ps1**: Set the default Server and ApiKey for Send-SeqEvent.ps1
- **Use-SqlSmo.ps1**: Find and load installed SQL SMO types.

<!-- generated 10/24/2016 16:29:36 -->
