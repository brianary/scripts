<#
.SYNOPSIS
Adds a VS Code MSSQL database connection to the repo.

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
[Parameter(Position=0,Mandatory=$true)][Alias('Name')][string]$ProfileName,
# The name of a server (and optional instance) to connect and use for the query.
[Parameter(Position=1,Mandatory=$true)][Alias('Server','DataSource')][string]$ServerInstance,
# The the database to connect to on the server.
[Parameter(Position=2,Mandatory=$true)][Alias('InitialCatalog')][string]$Database,
<#
The username to connect with. No password will be stored.
If no username is given, a trusted connection will be created.
#>
[Parameter(Position=3)][Alias('UID')][string]$UserName
)
Begin
{
	[psobject[]]$connections = Get-VSCodeSetting.ps1 mssql.connections -Workspace
	if(!$connections) {[psobject[]]$connections = @()}
}
Process
{
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
	$connections |ogv -Title Connections
	Set-VSCodeSetting.ps1 mssql.connections $connections -Workspace
}
