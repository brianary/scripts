PowerShell 5.1 Scripts
======================

A collection of legacy scripts that have been supplanted by newer scripts or modules for PowerShell 6+,
or have dependencies that are no longer available in PowerShell 6+.

- **[Add-SelectXmlDetails.ps1](Add-SelectXmlDetails.ps1)**: Adds OuterXml, Value, XPath, and Namespace properties to Select-Xml output.
- **[Add-Utf8Signature.ps1](Add-Utf8Signature.ps1)**: Adds the utf-8 signature (BOM) to a file.
- **[Add-Xml.ps1](Add-Xml.ps1)**: Insert XML into an XML document relative to a node found by Select-Xml.
- **[Convert-ScheduledTasksToJobs.ps1](Convert-ScheduledTasksToJobs.ps1)**: Converts Scheduled Tasks to Scheduled Jobs.
- **[ConvertFrom-Html.ps1](ConvertFrom-Html.ps1)**: Parses an HTML table into objects.
- **[ConvertFrom-UserAgent.ps1](ConvertFrom-UserAgent.ps1)**: Parse an HTTP User-Agent string.
- **[Disable-Certificate.ps1](Disable-Certificate.ps1)**: Sets the Archived property on a certificate.
- **[Enable-Certificate.ps1](Enable-Certificate.ps1)**: Unsets the Archived property on a certificate.
- **[Export-ScheduledJobs.ps1](Export-ScheduledJobs.ps1)**: Exports scheduled jobs as a PowerShell script that can be run to restore them.
- **[Export-ScheduledTasks.ps1](Export-ScheduledTasks.ps1)**: Exports scheduled tasks as a PowerShell script that can be run to restore them.
- **[Export-Server.ps1](Export-Server.ps1)**: Exports web server settings, shares, ODBC DSNs, and installed MSAs as PowerShell scripts and data.
- **[Export-SmbShares.ps1](Export-SmbShares.ps1)**: Export SMB shares using old NET SHARE command, to new New-SmbShare PowerShell commands.
- **[Export-WebConfiguration.ps1](Export-WebConfiguration.ps1)**: Exports IIS websites, app pools, and web apps as an idempotent PowerShell script to recreate them.
- **[Find-Certificate.ps1](Find-Certificate.ps1)**: Searches a certificate store for certificates.
- **[Format-Certificate.ps1](Format-Certificate.ps1)**: Generates a formatted name/description from a certificate.
- **[Get-CertificatePath.ps1](Get-CertificatePath.ps1)**: Gets the physical path on disk of a certificate's private key.
- **[Get-CertificatePermissions.ps1](Get-CertificatePermissions.ps1)**: Returns the permissions of a certificate's private key file.
- **[Get-FileContentsInfo.ps1](Get-FileContentsInfo.ps1)**: Returns whether the file is binary or text, and what encoding, line endings, and indents text files contain.
- **[Get-FileEncoding.ps1](Get-FileEncoding.ps1)**: Returns the encoding for a given file, suitable for passing to encoding parameters.
- **[Get-FileIndentCharacter.ps1](Get-FileIndentCharacter.ps1)**: Determines the indent characters used in a text file.
- **[Get-FileLineEndings.ps1](Get-FileLineEndings.ps1)**: Determines a file's line endings.
- **[Get-Html.ps1](Get-Html.ps1)**: Gets elements from a web response by tag name.
- **[Get-WebRequestBody.ps1](Get-WebRequestBody.ps1)**: Listens on a given port of the localhost, returning the body of a single web request, and responding with an empty 204.
- **[Grant-CertificateAccess.ps1](Grant-CertificateAccess.ps1)**: Grants certificate file read access to an app pool or user.
- **[Import-Html.ps1](Import-Html.ps1)**: Imports from an HTML table's rows, given a URL.
- **[New-Password.ps1](New-Password.ps1)**: Generate a new password.
- **[Read-WebRequest.ps1](Read-WebRequest.ps1)**: Parses an HTTP listener request.
- **[Receive-WebRequest.ps1](Receive-WebRequest.ps1)**: Listens for an HTTP request and returns an HTTP request & response.
- **[Remove-Utf8Signature.ps1](Remove-Utf8Signature.ps1)**: Removes the utf-8 signature (BOM) from a file.
- **[Remove-Xml.ps1](Remove-Xml.ps1)**: Removes a node found by Select-Xml from its XML document.
- **[Repair-Encoding.ps1](Repair-Encoding.ps1)**: Re-encodes Windows-1252 text that has been misinterpreted as UTF-8.
- **[Restart-HttpListener.ps1](Restart-HttpListener.ps1)**: Stops and restarts an HTTP listener.
- **[Save-CertificatePermissions.ps1](Save-CertificatePermissions.ps1)**: Saves the permissions of found certificates to a file.
- **[Select-XmlNodeValue.ps1](Select-XmlNodeValue.ps1)**: Returns the value of an XML node found by Select-Xml.
- **[Set-XmlAttribute.ps1](Set-XmlAttribute.ps1)**: Adds an XML attribute to an XML element found by Select-Xml.
- **[Set-XmlNodeValue.ps1](Set-XmlNodeValue.ps1)**: Sets the value of a node found by Select-Xml.
- **[Show-CertificatePermissions.ps1](Show-CertificatePermissions.ps1)**: Shows the permissions of a certificate's private key file.
- **[Show-ScheduledTask.ps1](Show-ScheduledTask.ps1)**: Provides a human-readable view of a scheduled task returned by Get-ScheduledTasks.
- **[Start-HttpListener.ps1](Start-HttpListener.ps1)**: Creates and starts an HTTP listener, for testing HTTP clients.
- **[Stop-HttpListener.ps1](Stop-HttpListener.ps1)**: Closes an HTTP listener.
- **[Suspend-HttpListener.ps1](Suspend-HttpListener.ps1)**: Pauses an HTTP listener.
- **[Sync-NewCertPermissions.ps1](Sync-NewCertPermissions.ps1)**: Updates permissions on certs when there is an older cert with the same friendly name.
- **[Test-BinaryFile.ps1](Test-BinaryFile.ps1)**: Indicates that a file contains binary data.
- **[Test-FinalNewline.ps1](Test-FinalNewline.ps1)**: Returns true if a file ends with a newline as required by the POSIX standard.
- **[Test-TextFile.ps1](Test-TextFile.ps1)**: Indicates that a file contains text.
- **[Test-Utf8Encoding.ps1](Test-Utf8Encoding.ps1)**: Determines whether a file can be parsed as UTF-8 successfully.
- **[Test-Utf8Signature.ps1](Test-Utf8Signature.ps1)**: Returns true if a file starts with a utf-8 signature (BOM).
- **[Wait-DriveNotBusy.ps1](Wait-DriveNotBusy.ps1)**: Uses WMI to check a physical drive for busyness, and waits until a threshhold is value is confirmed.
- **[Write-WebResponse.ps1](Write-WebResponse.ps1)**: Sends a text or binary response body to the HTTP listener client.

<!-- generated 12/04/2021 20:17:00 -->
