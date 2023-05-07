<#
.SYNOPSIS
Adds a VS Code MSSQL database connection to the repo.

.DESCRIPTION
The VSCode MSSQL extension can use saved database connections to connect to for queries,
and this allows adding those to the VSCode settings in the current git repo.

.INPUTS
Any object with these properties, used to construct a database connection entry:
* ProfileName or Name
* ServerInstance or Server or DataSource
* Database or InitialCatalog
* UserName or UID

.FUNCTIONALITY
VSCode

.LINK
https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql

.LINK
Get-VSCodeSetting.ps1

.LINK
Set-VSCodeSetting.ps1

.EXAMPLE
Add-VsCodeDatabaseConnection.ps1 ConnectionName ServerName\instance DatabaseName

Adds an MSSQL extension trusted connection named ConnectionName that
connects to the server ServerName\instance and database DatabaseName.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
# The name of the connection.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('Name')][string] $ProfileName,
# The name of a server (and optional instance) to connect and use for the query.
[Parameter(Position=1,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('Server','DataSource')][string] $ServerInstance,
# The the database to connect to on the server.
[Parameter(Position=2,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[Alias('InitialCatalog')][string] $Database,
<#
The username to connect with. No password will be stored.
If no username is given, a trusted connection will be created.
#>
[Parameter(Position=3,ValueFromPipelineByPropertyName=$true)]
[Alias('UID')][string] $UserName,
# Overwrite an existing profile with the same name.
[switch] $Force
)
Begin
{
	[psobject[]]$connections = Get-VSCodeSetting.ps1 mssql.connections -Workspace
	if(!$connections) {[psobject[]]$connections = @()}
}
Process
{
	if($connections |Where-Object profileName -eq $ProfileName)
	{
		if($Force) {$connections = $connections |Where-Object profileName -ne $ProfileName}
		else {Write-Verbose "Connection '$ProfileName' already exists"; return}
	}
	$connections +=
		if($UserName)
		{[pscustomobject]@{
			server             = $ServerInstance
			database           = $Database
			authenticationType = 'SqlLogin'
			profileName        = $ProfileName
			password           = ''
			user               = $UserName
			savePassword       = $false
		}}
		else
		{[pscustomobject]@{
			server             = $ServerInstance
			database           = $Database
			authenticationType = 'Integrated'
			profileName        = $ProfileName
			password           = ''
		}}
}
End
{
	$connections |ConvertTo-Json -Compress |Write-Verbose
	Set-VSCodeSetting.ps1 mssql.connections $connections -Workspace
}

