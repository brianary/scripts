<#
.Synopsis
    Exports IIS websites, app pools, and web apps as an idempotent PowerShell script to recreate them.

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

.Example
    Export-IisAppPools.ps1
#>

#Requires -Version 3
#Requires -Module WebAdministration
[CmdletBinding()] Param()

function Export-WebAppPools
{ #TODO: progress bar?
    '','# Application Pools'
    foreach($appPool in Get-Item iis:\AppPools\*)
    {
        "if(!(Test-Path '$($appPool.PSPath)'))"
        "{New-WebAppPool '$($appPool.Name)'}"
        if($appPool.managedRuntimeVersion -notin '','v4.0')
        {
            "Set-ItemProperty '$($appPool.PSPath)' managedRuntimeVersion $($appPool.managedRuntimeVersion)"
        }
        $processModel = Get-ItemProperty $appPool.PSPath processModel
        if($processModel.identityType -ne 'ApplicationPoolIdentity')
        {
            "Set-ItemProperty '$($appPool.PSPath)' processModel @{userName='$($processModel.userName)';identityType='$($processModel.identityType)'}"
        }
    }
}

function Export-Websites
{ #TODO: progress bar?
    '','# Websites'
    foreach($website in Get-Website)
    {
        @"
if(!(Test-Path 'IIS:\Sites\$($website.name)'))
{@{
    Name            = '$($website.name)'
    PhysicalPath    = '$($website.physicalPath)'
    ApplicationPool = '$($website.applicationPool)'
}|% {New-Website @_}}
"@
        foreach($binding in $website.bindings.Collection)
        {
            $name,$protocol,$ipAddress,$port,$hostHeader = 
                $website.name,$binding.protocol,$binding.bindingInformation -split ':',3
            @"
if(!(Get-WebBinding -Name '$name' -Protocol $protocol -IPAddress $ipAddress -Port $port -HostHeader '$hostHeader'))
@{
    Name       = '$name'
    Protocol   = '$protocol'
    IPAddress  = '$ipAddress'
    Port       = '$port'
    HostHeader = '$hostHeader'
    $(if($protocol -ne 'https'){'#'})SslFlags = 0 #TODO: cert, certificate type, & binding
} |% {New-WebBinding @_}
"@
        }
    }
}

function Export-WebApplications
{ #TODO: progress bar?
    '','# Web Applications'
    foreach($webapp in Get-WebApplication)
    {
        $path = "IIS:\Sites\$($webapp.GetParentElement()['name'])\$($webapp.path.Trim('/'))"
        @"
if(!(Test-Path '$path'))
{@{
    Site            = '$($webapp.GetParentElement()['name'])'
    Name            = '$($webapp.path.Trim('/'))'
    PhysicalPath    = '$($webapp.PhysicalPath)'
    ApplicationPool = '$($webapp.applicationPool)'
} |% {New-WebApplication @_}}
"@
        $value = Get-WebConfigurationProperty $path -Filter system.webServer/security/access -Name SslFlags
        if($value)
        {
            "Set-WebConfigurationProperty '$path' -Filter system.webServer/security/access -Name SslFlags -Value '$value'"
        }
        foreach($auth in 'digest','basic','anonymous','windows')
        { #TODO: error messages?
            $authentication = "system.webServer/security/authentication/${auth}Authentication"
            $value = Get-WebConfigurationProperty $path -Filter $authentication -Name enabled
            if($value)
            {
                "Set-WebConfigurationProperty '$path' -Filter $authentication -Name enabled -Value $($value.Value)"
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
}

"#Requires -Module WebAdministration"
Export-WebAppPools
Export-Websites
Export-WebApplications
