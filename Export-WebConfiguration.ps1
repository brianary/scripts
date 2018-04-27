<#
.Synopsis
    Exports IIS websites, app pools, and web apps as an idempotent PowerShell script to recreate them.

.Outputs
    System.String, PowerShell strings to create and configure IIS websites, app pools, and web apps
    not found, as configured on the local machine.

.Link
    https://chocolatey.org/

.Link
    https://docs.microsoft.com/en-us/iis/configuration/system.webserver/

.Link
    https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-creating-web-sites-web-applications-virtual-directories-and-application-pools

.Link
    https://blog.kloud.com.au/2013/04/18/an-overview-of-server-name-indication-sni-and-creating-an-iis-sni-web-ssl-binding-using-powershell-in-windows-server-2012/

.Link
    https://stackoverflow.com/a/26391894/54323

.Link
    https://docs.microsoft.com/en-us/iis/configuration/system.applicationHost/applicationPools/add/processModel

.Link
    https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-changing-simple-settings-in-configuration-sections

.Link
    https://stackoverflow.com/a/14879480/54323

.Link
    https://stackoverflow.com/a/25807484/54323

.Link
    https://blogs.iis.net/jeonghwan/examples-of-iis-powershell-cmdlets

.Link
    https://docs.microsoft.com/en-us/iis/manage/powershell/powershell-snap-in-configuring-ssl-with-the-iis-powershell-snap-in

.Link
    https://github.com/PowerShell/xWebAdministration

.Link
    Get-WebGlobalModule

.Link
    New-WebAppPool

.Link
    Get-Website

.Link
    New-Website

.Link
    Get-WebBinding

.Link
    New-WebBinding

.Link
    Get-WebApplication

.Link
    New-WebApplication

.Link
    Set-WebConfigurationProperty

.Link
    Write-Progress

.Link
    Get-Item

.Link
    Get-ItemProperty

.Link
    Set-ItemProperty

.Example
    Export-WebConfiguration.ps1
#>

#Requires -Version 3
#Requires -RunAsAdministrator
#Requires -Module WebAdministration
[CmdletBinding()] Param()

function Export-Header
{
    @"
<#
.Synopsis
    Imports IIS websites, app pools, and web apps exported from $env:ComputerName
#>

#Requires -Version 3
#Requires -RunAsAdministrator
#Requires -Module WebAdministration
[CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact='High')] Param()

`$todofile = [io.path]::ChangeExtension(`$PSCommandPath,'md')
@"
Manual TODO List
================

`"@ |Out-File `$todofile utf8
function Write-Todo([string]`$message)
{
    Write-Warning "TODO: `$message (see `$todofile)"
    "1. `$message" |Add-Content `$todofile
}
"@
}

function Export-GlobalModulesCheck
{
    @"

function Ping-GlobalModules
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact='High')] Param()
    if(!(`$PSCmdlet.ShouldProcess('global modules','check'))){return}
    `$modulepkg =
    @{
        ApplicationInitializationModule = 'iis-application-initialization'
        AppWarmupModule                 = 'iis-application-initialization'
        RewriteModule                   = 'urlrewrite'
    }
    if(!(Get-Command cinst -CommandType Application)) {`$modulepkg.Clear()}
"@
    [object[]]$globalModules = Get-WebGlobalModule
    $i,$max = 0,($globalModules.Count/100.)
    foreach($globalModule in $globalModules)
    {
        $name = $globalModule.Name
        Write-Progress 'Exporting global module checks' $name -PercentComplete ($i/$max)
        @"
    Write-Progress 'Checking global modules' '$name' -PercentComplete $([int]($i++/$max))
    if(!(Get-WebGlobalModule '$name'))
    {Write-Todo 'Install missing global module $name if needed ($($globalModule.Image))'}
    elseif(`$modulepkg.ContainsKey('$name') -and `$PSCmdlet.ShouldProcess(`$modulepkg['$name'],'install'))
    {try{cinst (`$modulepkg['$name']) -y}catch{Write-Error "Unable to install $name. Is Chocolatey installed?"}}
    else
    {Write-Verbose 'Global module $name found'}
"@
    }
    Write-Progress 'Exporting global module checks' -Completed
    @"
    Write-Progress 'Importing global module checks' -Completed
}
"@
}

function Export-WebAppPools
{
    @"

function Import-WebAppPools
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact='High')] Param()
    if(!(`$PSCmdlet.ShouldProcess('web app pools','import'))){return}
"@
    [object[]]$appPools = Get-Item IIS:\AppPools\*
    $i,$max = 0,($appPools.Count/100.)
    foreach($appPool in $appPools)
    {
        $path = "IIS:\AppPools\$($appPool.Name)"
        Write-Progress 'Exporting application pools' $path -PercentComplete ($i/$max)
        @"
    Write-Progress 'Importing application pools' '$path' -PercentComplete $([int]($i++/$max))
    if(!(Test-Path '$path'))
    {New-WebAppPool '$($appPool.Name)'}
    else
    {Write-Verbose 'App pool $($appPool.Name) found'}
"@
        if($appPool.managedRuntimeVersion -notin '','v4.0'){@"
    Set-ItemProperty '$path' managedRuntimeVersion $($appPool.managedRuntimeVersion)
"@}
        $processModel = Get-ItemProperty $path processModel
        if($processModel.identityType -ne 'ApplicationPoolIdentity'){@"
    Set-ItemProperty '$path' processModel @{userName='$($processModel.userName)';identityType='$($processModel.identityType)'}
"@}
    }
    Write-Progress 'Exporting application pools' -Completed
    @"
    Write-Progress 'Importing application pools' -Completed
}
"@
}

function Export-Websites
{
    @"

function Import-Websites
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact='High')] Param()
    if(!(`$PSCmdlet.ShouldProcess('websites','import'))){return}
"@
    [object[]]$websites = Get-Website
    $i,$max = 0,($websites.Count/100.)
    foreach($website in $websites)
    {
        $name = $website.name
        $primaryBinding = Get-WebBinding $name |select -First 1
        $ipAddress,$port,$hostHeader =
            $primaryBinding.bindingInformation -split ':',3
        Write-Progress 'Exporting websites' $name -PercentComplete ($i/$max)
        @"
    Write-Progress 'Importing websites' '$name' -PercentComplete $([int]($i++/$max))
    if(!(Test-Path 'IIS:\Sites\$name'))
    {@{
        Name            = '$name'
        PhysicalPath    = '$($website.physicalPath)'
        ApplicationPool = '$($website.applicationPool)'
        Ssl             = `$$($primaryBinding.protocol -eq 'https')
        IPAddress       = '$ipAddress'
        Port            = $port
        HostHeader      = '$hostHeader'
    }|% {New-Website @_}}
    else
    {Write-Verbose 'Website $name found'}
"@
        foreach($binding in Get-WebBinding $name |select -Skip 1)
        {
            $protocol,$ipAddress,$port,$hostHeader =
                $binding.protocol,$binding.bindingInformation -split ':',3
            @"
    if(!(Get-WebBinding -Name '$name' -Protocol $protocol -IPAddress $ipAddress -Port $port -HostHeader '$hostHeader'))
    {@{
        Name       = '$name'
        Protocol   = '$protocol'
        IPAddress  = '$ipAddress'
        Port       = '$port'
        HostHeader = '$hostHeader'
    } |% {New-WebBinding @_}}
    else
    {Write-Verbose 'Website $($website.name) $protocol binding ${ipAddress}:${port}:${hostHeader} found'}
"@
        }
    }
    Write-Progress 'Exporting websites' -Completed
    @"
    Write-Progress 'Importing websites' -Completed
}
"@
}

function Export-ServerCertificates
{
    @"
function Import-ServerCertificates
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact="High")] Param()
    if(!(`$PSCmdlet.ShouldProcess('server certificates','import'))){return}
"@
    #TODO: gcm -mo pki
    @"
    Write-Progress 'Importing server certificates' -Completed
}
"@
}

function Get-LocationConfigPaths([string]$xpath)
{
    Select-Xml "/configuration/location[system.webServer/$xpath]/@path" (Get-WebConfigFile) |% {$_.Node.Value}
}

function Export-WebApplications
{
    [object[]]$webapps = Get-WebApplication
    $i,$max,$functions = 0,($webapps.Count/100.),@()
    foreach($webapp in $webapps)
    {
        $site = $webapp.GetParentElement()['name']
        $apppath = $webapp.path.Trim('/')
        $path = "IIS:\Sites\$site\$apppath"
        $funcname = "Import-WebApplication_$($site -replace '\W+','')_$($apppath -replace '\W+','')"
        $functions += $funcname
        @"
function $funcname
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact="High")] Param()
    if(!(`$PSCmdlet.ShouldProcess('$site web application: $apppath','import'))){return}
"@
        $local:PSDefaultParameterValues = @{
            'Get-WebConfiguration:PSPath'           = 'MACHINE/WEBROOT/APPHOST'
            'Get-WebConfiguration:Location'         = "$site/$apppath"
            'Get-WebConfigurationProperty:PSPath'   = 'MACHINE/WEBROOT/APPHOST'
            'Get-WebConfigurationProperty:Location' = "$site/$apppath"
        }
        $cfgcontext = "-PSPath MACHINE/WEBROOT/APPHOST -Location '$site/$apppath'"
        if(!($webapp.PhysicalPath)){throw "Physical paths on web applications aren't accessible. Try restarting PowerShell."}
        Write-Progress 'Exporting web applications' $path -Current $webapp.applicationPool -Percent ($i/$max)
        @"
    Write-Progress 'Importing web applications' '$path' -Current '$($webapp.applicationPool)' -Percent $([int]($i++/$max))
    if(!(Get-WebApplication '$apppath' -Site '$site'))
    {@{
        Site            = '$site'
        Name            = '$apppath'
        PhysicalPath    = '$($webapp.PhysicalPath)'
        ApplicationPool = '$($webapp.applicationPool)'
    } |% {New-WebApplication @_}}
    else
    {Write-Verbose 'Web application $path found'}
"@
        Select-Xml "/configuration/location[@path='$site/$apppath']/system.webServer" (Get-WebConfigFile) |
            % {$_.Node.SelectNodes('*')} -pv cfg |
            % {
                if($_.LocalName -ne 'security') {"The $($_.LocalName) may be customized for $path"}
                else
                {
                    if($cfg.access){[psobject]@{
                        Filter = 'system.webServer/security/access'
                        Name   = 'SslFlags'
                        Value  = $_.access.sslFlags
                    }}
                    $cfg.SelectNodes('authentication/*') |
                        % {
                            if($_.userName){"Set $path username to $($_.userName)"}
                            if($_.InnerXml){"Configure $path $($_.LocalName) for $($_.InnerXml -replace '(?m)^\s+|[\r\n]+','')"}
                            [pscustomobject]@{
                                Filter = "system.webServer/security/authentication/$($_.LocalName)"
                                Name   = 'enabled'
                                Value  = $_.enabled
                            }
                        }
                }
            } |
            % {
                if($_ -is [string])
                {@"
    Write-Todo '$_'
"@}
                else
                {@"
    try{Set-WebConfigurationProperty $cfgcontext -Filter '$($_.Filter)' -Name '$($_.Name)' -Value '$($_.Value)'}
    catch{Write-Todo "Set $path $($_.Filter) $($_.Name) to '$($_.Value)'"}
"@}}
        @"
}
"@
    }
    @"
function Import-WebApplications
{
    $($functions -join "`r`n    ")
    Write-Progress 'Importing web applications' -Completed
}
"@
    Write-Progress 'Exporting web applications' -Completed
}

function Export-Footer
{
    @"

Ping-GlobalModules
Import-WebAppPools
Import-Websites
Import-WebApplications
"@
}

Export-Header
Export-GlobalModulesCheck
Export-WebAppPools
Export-Websites
Export-WebApplications
Export-Footer
