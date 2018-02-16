<#
.Synopsis
    Adds a VS Code MSSQL database connection to the repo.

.Parameter ProfileName
    The name of the connection.

.Parameter ServerInstance
    The name of a server (and optional instance) to connect and use for the query.

.Parameter Database
    The the database to connect to on the server.

.Parameter UserName
    The username to connect with. No password will be stored.
    If no username is given, a trusted connection will be created.

.Link
    https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql

.Example
    Add-VsCodeDatabaseConnection.ps1 ConnectionName ServerName\instance DatabaseName

    Adds an MSSQL extension trusted connection named ConnectionName that
    connects to the server ServerName\instance and database DatabaseName.
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][Alias('Name')][string]$ProfileName,
[Parameter(Position=1,Mandatory=$true)][Alias('Server','DataSource')][string]$ServerInstance,
[Parameter(Position=2,Mandatory=$true)][Alias('InitialCatalog')][string]$Database,
[Parameter(Position=3)][Alias('UID')][string]$UserName
)
Begin
{
    Use-Command.ps1 git "$env:ProgramFiles\Git\cmd\git.exe" -choco git
    $connections = @()
}
Process
{
    $connections +=
        if($UserName)
        {[PSCustomObject]@{
            server             = $ServerInstance
            database           = $Database
            authenticationType = 'SqlLogin'
            profileName        = $ProfileName
            password           = ''
            user               = $UserName
            savePassword       = $false
        }}
        else
        {[PSCustomObject]@{
            server             = $ServerInstance
            database           = $Database
            authenticationType = 'Integrated'
            profileName        = $ProfileName
            password           = ''
        }}
}
End
{
    $repo = git rev-parse --show-toplevel
    if(!(Test-Path $repo\.vscode -PathType Container)) {mkdir $repo\.vscode |Out-Null}
    ${settings.json} = "$repo\.vscode\settings.json"
    Write-Verbose "Updating ${settings.json}"
    $settings = @{}
    if(Test-Path ${settings.json} -PathType Leaf)
    {
        $settings = Get-Content ${settings.json} -Raw |ConvertFrom-Json
        if('mssql.connections' -in $settings.PSObject.Properties.Name)
        {
            $csnew = $connections |? profileName -notin $settings.'mssql.connections'.profileName
            if(!$csnew){Write-Verbose "No new connections to add."; return}
            $settings.'mssql.connections' += $csnew
        }
        else
        {
            Add-Member -InputObject $settings -MemberType NoteProperty -Name 'mssql.connections' -Value $connections
        }
    }
    else
    {
        $settings = [pscustomobject]@{'mssql.connections'=$connections}
    }
    ConvertTo-Json $settings -Depth 5 |Out-File ${settings.json} utf8
}

