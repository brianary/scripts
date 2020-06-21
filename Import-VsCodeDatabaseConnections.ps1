<#
.Synopsis
    Adds config XDT connection strings to VSCode settings.

.Link
    https://marketplace.visualstudio.com/items?itemName=ms-mssql.mssql

.Link
    http://code.visualstudio.com/

.Link
    https://git-scm.com/docs/git-rev-parse

.Link
    Get-ConfigConnectionStringBuilders.ps1

.Link
    Split-FileName.ps1

.Link
    Import-Variables.ps1

.Link
    ConvertFrom-Json

.Link
    ConvertTo-Json

.Link
    Add-Member

.Link
    Test-Path

.Example
    Import-VsCodeDatabaseConnections.ps1

    Adds any new (by name) connection strings found in XDT .config files into
    the .vscode/settings.json mssql.connections collection for the mssql extension.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param()

function Get-ConfigConnections
{
    $connections = @()
    foreach($config in (ls -Recurse -Filter *.config |% FullName))
    {
        foreach($cs in (Get-ConfigConnectionStringBuilders.ps1 $config))
        {
            $name = $cs.Name + '.' + ($config |Split-FileName.ps1 |Split-FileName.ps1 -Extension).Trim('.')
            if($connections -and $name -in $connections.profileName){Write-Verbose "Already have a '$name' connection."; continue}
            Import-Variables.ps1 $cs.ConnectionString
            $conn = @{
                server             = ${Data Source}
                database           = ${Initial Catalog}
                authenticationType = if(${Integrated Security}){'Integrated'}else{'SqlLogin'}
                profileName        = $name
                password           = ''
            }
            if(!${Integrated Security}){
                $conn['user']         = ${User ID}
                $conn['savePassword'] = $false
            }
            Write-Verbose "Found '$($conn.profileName)' in $config"
            $connections += New-Object psobject -Property $conn
        }
    }
    Write-Verbose "Found $($connections.Count) connection strings."
    $connections
}

function Add-VsCodeConnections([object[]]$connections)
{
    $repo = git rev-parse --show-toplevel
    if(!(Test-Path $repo\.vscode -PathType Container)) {mkdir $repo\.vscode}
    ${settings.json} = "$repo\.vscode\settings.json"
    Write-Verbose "Updating ${settings.json}"
    $settings = @{}
    if(Test-Path ${settings.json} -PathType Leaf)
    {
        $settings = Get-Content ${settings.json} -Raw |ConvertFrom-Json
        if($settings |Get-Member mssql.connections -MemberType NoteProperty)
        {
            $csnew = $connections |? profileName -notin $settings.'mssql.connections'.profileName
            if(!$csnew){Write-Verbose "No new connections to add."; return}
            $settings.'mssql.connections' += $csnew
        }
        else
        {
            Add-Member -InputObject $settings -MemberType NoteProperty -Name 'mssql.connections' -Value $connections
        }
        mv ${settings.json} "${settings.json}.$(Get-Date -f yyyyMMddHHmmss)"
    }
    else
    {
        $settings = [pscustomobject]@{'mssql.connections'=$connections}
    }
    ConvertTo-Json $settings -Depth 5 |Out-File ${settings.json} utf8
}

$connections = Get-ConfigConnections
if(!$connections){Write-Verbose 'Nothing to do.'}
else{Add-VsCodeConnections $connections}
