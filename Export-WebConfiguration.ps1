<#
.Synopsis
    Exports IIS websites, app pools, and web apps as an idempotent PowerShell script to recreate them.

.Outputs
    System.String, PowerShell strings to create and configure IIS websites, app pools, and web apps
    not found, as configured on the local machine.

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

.Example
    Export-WebConfiguration.ps1
#>

#Requires -Version 3
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
#Requires -Module WebAdministration
[CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact='High')] Param()
"@
}

function Export-GlobalModulesCheck
{
    @"

function Ping-GlobalModules
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact='High')] Param()
    if(!(`$PSCmdlet.ShouldProcess('global modules','check'))){return}
"@
    [object[]]$globalModules = Get-WebGlobalModule
    $i,$max = 0,($globalModules.Count/100.)
    foreach($globalModule in $globalModules)
    {
        Write-Progress 'Exporting global module checks' $globalModule.Name -PercentComplete ($i/$max)
        @"
    Write-Progress 'Checking global modules' '$($globalModule.Name)' -PercentComplete $([int]($i++/$max))
    if(!(Get-WebGlobalModule '$($globalModule.Name)'))
    {Write-Warning 'Global module $($globalModule.Name) not found ($($globalModule.Image))'}
    else
    {Write-Verbose 'Global module $($globalModule.Name) found'}
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
        Write-Progress 'Exporting websites' $website.name -PercentComplete ($i/$max)
        @"
    Write-Progress 'Importing websites' '$($website.name)' -PercentComplete $([int]($i++/$max))
    if(!(Test-Path 'IIS:\Sites\$($website.name)'))
    {@{
        Name            = '$($website.name)'
        PhysicalPath    = '$($website.physicalPath)'
        ApplicationPool = '$($website.applicationPool)'
    }|% {New-Website @_}}
    else
    {Write-Verbose 'Website $($website.name) found'}
"@
        foreach($binding in $website.bindings.Collection)
        {
            $name,$protocol,$ipAddress,$port,$hostHeader = 
                $website.name,$binding.protocol,$binding.bindingInformation -split ':',3
            @"
    if(!(Get-WebBinding -Name '$name' -Protocol $protocol -IPAddress $ipAddress -Port $port -HostHeader '$hostHeader'))
    {@{
        Name       = '$name'
        Protocol   = '$protocol'
        IPAddress  = '$ipAddress'
        Port       = '$port'
        HostHeader = '$hostHeader'
        $(if($protocol -ne 'https'){'#'})SslFlags = 0 #TODO: cert, certificate type, & binding
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

function Export-WebApplications
{
    @"
function Import-WebApplications
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact="High")] Param()
    if(!(`$PSCmdlet.ShouldProcess('web applications','import'))){return}
"@
    [object[]]$webapps = Get-WebApplication
    $i,$max = 0,($webapps.Count/100.)
    foreach($webapp in $webapps)
    {
        $path = "IIS:\Sites\$($webapp.GetParentElement()['name'])\$($webapp.path.Trim('/'))"
        if(!($webapp.PhysicalPath)){throw "Physical paths on web applications aren't accessible. Try restarting PowerShell."}
        Write-Progress 'Exporting web applications' $path -Current $webapp.applicationPool -Percent ($i/$max)
        @"
    Write-Progress 'Importing web applications' '$path' -Current '$($webapp.applicationPool)' -Percent $([int]($i++/$max))
    if(!(Test-Path '$path'))
    {@{
        Site            = '$($webapp.GetParentElement()['name'])'
        Name            = '$($webapp.path.Trim('/'))'
        PhysicalPath    = '$($webapp.PhysicalPath)'
        ApplicationPool = '$($webapp.applicationPool)'
    } |% {New-WebApplication @_}}
    else
    {Write-Verbose 'Web application $path found'}
"@
        $value = Get-WebConfigurationProperty $path -Filter system.webServer/security/access -Name SslFlags
        if($value){@"
    Set-WebConfigurationProperty '$path' -Filter system.webServer/security/access -Name SslFlags -Value '$value'
"@}
        foreach($auth in 'digest','basic','anonymous','windows')
        {
            $authentication = "system.webServer/security/authentication/${auth}Authentication"
            $value = Get-WebConfigurationProperty $path -Filter $authentication -Name enabled
            if($value)
            {@"
    Set-WebConfigurationProperty '$path' -Filter $authentication -Name enabled -Value $($value.Value)
"@
                if($auth -eq 'windows')
                {
                    #TODO: Get-WebConfiguration IIS:\Sites\appytest\Store -Filter system.webServer/security/authentication/windowsAuthentication/providers
                    # .Collection : Negotiate, NTLM
                }
            }
        }
        #TODO: Set-WebConfigurationProperty stuff
        # asp,aspNetCore
        # staticContent?
        # defaultDocument?
        # modules,handlers?
    }
    Write-Progress 'Exporting web applications' -Completed
    @"
    Write-Progress 'Importing web applications' -Completed
}
"@
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
