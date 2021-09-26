PowerShell 5.1 Scripts
======================

A collection of legacy scripts that have been supplanted by newer scripts or modules for PowerShell 6+,
or have dependencies that are no longer available in PowerShell 6+.

- **[Add-SelectXmlDetails.ps1](Add-SelectXmlDetails.ps1)**: Adds OuterXml, Value, XPath, and Namespace properties to Select-Xml output.
- **[Add-Xml.ps1](Add-Xml.ps1)**: Insert XML into an XML document relative to a node found by Select-Xml.
- **[Convert-ScheduledTasksToJobs.ps1](Convert-ScheduledTasksToJobs.ps1)**: Converts Scheduled Tasks to Scheduled Jobs.
- **[ConvertFrom-Html.ps1](ConvertFrom-Html.ps1)**: Parses an HTML table into objects.
- **[ConvertFrom-UserAgent.ps1](ConvertFrom-UserAgent.ps1)**: Parse an HTTP User-Agent string.
- **[Disable-Certificate.ps1](Disable-Certificate.ps1)**: Sets the Archived property on a certificate.
- **[Enable-Certificate.ps1](Enable-Certificate.ps1)**: Unsets the Archived property on a certificate.
- **[Export-ScheduledJobs.ps1](Export-ScheduledJobs.ps1)**: Exports scheduled jobs as a PowerShell script that can be run to restore them.
- **[Export-ScheduledTasks.ps1](Export-ScheduledTasks.ps1)**: Exports scheduled tasks as a PowerShell script that can be run to restore them.
- **[Find-Certificate.ps1](Find-Certificate.ps1)**: Searches a certificate store for certificates.
- **[Format-Certificate.ps1](Format-Certificate.ps1)**: Generates a formatted name/description from a certificate.
- **[Get-CertificatePath.ps1](Get-CertificatePath.ps1)**: Gets the physical path on disk of a certificate's private key.
- **[Get-CertificatePermissions.ps1](Get-CertificatePermissions.ps1)**: Returns the permissions of a certificate's private key file.
- **[Get-Html.ps1](Get-Html.ps1)**: Gets elements from a web response by tag name.
- **[Get-WebRequestBody.ps1](Get-WebRequestBody.ps1)**: Listens on a given port of the localhost, returning the body of a single web request, and responding with an empty 204.
- **[Grant-CertificateAccess.ps1](Grant-CertificateAccess.ps1)**: Grants certificate file read access to an app pool or user.
- **[Import-Html.ps1](Import-Html.ps1)**: Imports from an HTML table's rows, given a URL.
- **[New-Password.ps1](New-Password.ps1)**: Generate a new password.
- **[Read-WebRequest.ps1](Read-WebRequest.ps1)**: Parses an HTTP listener request.
- **[Receive-WebRequest.ps1](Receive-WebRequest.ps1)**: Listens for an HTTP request and returns an HTTP request & response.
- **[Remove-Xml.ps1](Remove-Xml.ps1)**: Removes a node found by Select-Xml from its XML document.
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
- **[Wait-DriveNotBusy.ps1](Wait-DriveNotBusy.ps1)**: Uses WMI to check a physical drive for busyness, and waits until a threshhold is value is confirmed.
- **[Write-WebResponse.ps1](Write-WebResponse.ps1)**: Sends a text or binary response body to the HTTP listener client.

<!-- generated 09/25/2021 19:25:00 -->
