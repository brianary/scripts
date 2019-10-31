<#
.Synopsis
	Adds a NoteProperty to a PSObject, calculating the value with the object in context.

.Parameter Name
	The name of the NoteProperty to add to the object.

.Parameter Value
	The expression to use to set the value of the NoteProperty.

.Parameter InputObject
	The object to add the NoteProperty to.

.Parameter PassThru
	Returns the object with the NoteProperty added.
	Normally there is no output.

.Link
	Add-Member

.Example
	Get-ChildItem Get-*.ps1 |Add-NoteProperty.ps1 Size {Format-ByteUnits.ps1 $Length -Precision 1} -Properties Length -PassThru |Format-Table Size,Name -AutoSize

	Size   Name
	----   ----
	8.1KB  Get-AspNetEvents.ps1
	840    Get-AssemblyFramework.ps1
	7KB    Get-CertificatePath.ps1
	1.5KB  Get-CertificatePermissions.ps1
	38.3KB Get-CharacterDetails.ps1
	1.1KB  Get-ClassicAspEvents.ps1
	1.3KB  Get-CommandPath.ps1
	1.2KB  Get-ConfigConnectionStringBuilders.ps1
	4.9KB  Get-ConsoleColors.ps1
	1.4KB  Get-ContentSecurityPolicy.ps1
	617    Get-Dns.ps1
	2.4KB  Get-EnumValues.ps1
	1.1KB  Get-Html.ps1
	6KB    Get-IisLog.ps1
	1.9KB  Get-LibraryVulnerabilityInfo.ps1
	2.7KB  Get-NetFrameworkVersions.ps1
	969    Get-RepoName.ps1
	3.3KB  Get-SslDetails.ps1
	4.2KB  Get-SystemDetails.ps1
	6.8KB  Get-TypeAccelerators.ps1
	1.2KB  Get-XmlNamespaces.ps1
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Name,
[Parameter(Position=1,Mandatory=$true)][ScriptBlock] $Value,
[Alias('Import')][string[]] $Properties = @(),
[Parameter(ValueFromPipeline=$true,Mandatory=$true)][PSObject] $InputObject,
[switch] $PassThru,
[switch] $Force
)
Process
{
	[psvariable[]] $context = New-Object psvariable _,$InputObject
	if($Properties -and $Properties.Length)
	{
		if($Properties[0] -eq '*')
		{
			$context += $InputObject.PSObject.Properties |
				foreach {New-Object psvariable $_.Name,$_.Value}
		}
		else
		{
			$context += $InputObject.PSObject.Properties |
				where Name -in $Properties |
				foreach {New-Object psvariable $_.Name,$_.Value}
		}
	}
	[psobject[]] $v = $Value.InvokeWithContext($null,$context,$null)
	Add-Member -InputObject $InputObject -MemberType NoteProperty -Name $Name `
		-Value $(if($v.Length -eq 1){$v[0]}else{$v}) -PassThru:$PassThru -Force:$Force
}
