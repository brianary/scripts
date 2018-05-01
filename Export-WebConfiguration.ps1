<#
.Synopsis
    Exports IIS websites, app pools, and web apps as an idempotent PowerShell script to recreate them.

.Parameter Path
    File to write import script text to.

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
##Requires -RunAsAdministrator
#Requires -Module WebAdministration
[CmdletBinding()] Param(
[string]$Path = "Import-${env:ComputerName}WebConfiguration.ps1",
[Security.Cryptography.X509Certificates.X509Store[]] $Stores =
    ((Get-Item 'Cert:\LocalMachine\My'), (Get-Item 'Cert:\LocalMachine\TrustedPeople')),
[Security.Cryptography.X509Certificates.X509KeyStorageFlags] $X509KeyStorageFlags = 'Exportable,MachineKeySet,PersistKeySet'
)

try {[void][Web.Security.Membership]} catch {Add-Type -AN System.Web}

function Test-Administrator
{
    ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).`
        IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

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

`$todofile = [io.path]::ChangeExtension(`$PSCommandPath,'txt')
@"
Manual $env:ComputerName Web Configuration TODO List
======================================================

`"@ |Out-File `$todofile utf8
function Write-Todo([string]`$message)
{
    Write-Warning "TODO: `$message (see `$todofile)"
    "- [ ] `$message" |Add-Content `$todofile
}
"@
}

function Get-CertificateFriendliestName(
    [Parameter(Position=0,ValueFromPipeline=$true)][Security.Cryptography.X509Certificates.X509Certificate2]$cert,
    [switch]$WithExpiry)
{Process{
    if(!$cert.FriendlyName) {return "$($cert.Subject) expiring $($cert.NotAfter)"}
    else {return "$($cert.FriendlyName) expiring $($cert.NotAfter)"}
}}

function Get-CertificateImportName([Parameter(Position=0)][Security.Cryptography.X509Certificates.X509Store]$store,
    [Parameter(Position=1,ValueFromPipeline=$true)][Security.Cryptography.X509Certificates.X509Certificate2]$cert)
{Process{
    $basename = "Import-CertificateTo_$($store.Location)_$($store.Name)_"
    if(!$cert.FriendlyName) {return "$basename$($cert.Thumbprint)"}
    else {return "$basename$($cert.FriendlyName -replace '\W+','_')"}
}}

function Export-CertificateFrom([Parameter(Position=0)][Security.Cryptography.X509Certificates.X509Store]$store,
[Parameter(Position=1)][decimal]$PercentDenominator,
[Parameter(Position=2,ValueFromPipeline=$true)][Security.Cryptography.X509Certificates.X509Certificate2]$cert)
{Begin{$i = 0} Process{
    $location,$name,$secret,$percent,$certname,$Local:OFS =
        $store.Location,$store.Name,[Web.Security.Membership]::GeneratePassword(40,12),
        [math]::Floor($i++/$PercentDenominator),(Get-CertificateFriendliestName $cert),''
    Write-Progress "Exporting certificates from Cert:\$location\$name" $certname -Current $cert.Subject -Percent $percent
    $qcertname = "$($certname -replace "'","''")"
    $action =
        try
        {@"
`$store.Add((New-Object Security.Cryptography.X509Certificates.X509Certificate2 ([convert]::FromBase64String(@'
$([convert]::ToBase64String($cert.Export('Pfx',$secret),'InsertLineBreaks'))
'@)),'$($secret -replace "'","''")','$X509KeyStorageFlags'))
"@}
        catch
        {
            Write-Warning "Unable to export ${certname}: $_"
            $err = "$_" -replace "'","''" -replace '[\r\n]+',''
            "Write-Warning 'Could not import $qcertname because it did not export successfully: $err'"
        }
    @"

function $(Get-CertificateImportName $store $cert)
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact="High")] Param(
    [Parameter(Position=0)][Security.Cryptography.X509Certificates.X509Store]`$store
    )
    if(!(`$PSCmdlet.ShouldProcess('$qcertname','import into Cert:\$location\$name'))){return}
    Write-Progress 'Importing certificates into Cert:\$location\$name' '$qcertname' ``
        -Current '$($cert.Subject -replace "'","''")' -Percent $percent
    $action
}
"@
}}

function Get-StoreImportName([Parameter(ValueFromPipeline=$true)]
    [Security.Cryptography.X509Certificates.X509Store]$store)
{Process{
    return "Import-CertificateTo_$($store.Location)_$($store.Name)"
}}

function Export-CertificatesFrom([Parameter(ValueFromPipeline=$true)]
    [Security.Cryptography.X509Certificates.X509Store]$store)
{Process{ # Export-PfxCertificate is easier, but a bit too new to be broadly useful
    $location,$name,$Local:OFS = $store.Location,$store.Name,"`r`n    "
    $certs = Get-ChildItem Cert:\$location\$name
    $certs |Export-CertificateFrom $store ($certs.Length/100)
    @"

function $(Get-StoreImportName $store)
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact="High")] Param()
    `$store = Get-Item Cert:\$location\$name
    if(!(`$PSCmdlet.ShouldProcess('Cert:\$location\$name server certificates','import'))){return}
    `$store.Open('OpenExistingOnly, ReadWrite')
    $($certs |Get-CertificateImportName $store |% {"$_ `$store"})
    `$store.Close()
    `$store.Dispose()
    Write-Progress 'Importing certificates into Cert:\$location\$name' -Completed
}
"@
    Write-Progress "Exporting certificates from Cert:\$location\$name" -Completed
}}

function Export-Certificates
{
    $Local:OFS = "`r`n    "
    $Stores |Export-CertificatesFrom
    @"

function Import-Certificates
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact="High")] Param()
    $($Stores |Get-StoreImportName)
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
        $iispath = "IIS:\AppPools\$($appPool.Name)"
        Write-Progress 'Exporting application pools' $iispath -PercentComplete ($i/$max)
        @"
    Write-Progress 'Importing application pools' '$iispath' -PercentComplete $([int]($i++/$max))
    if(!(Test-Path '$iispath'))
    {New-WebAppPool '$($appPool.Name)'}
    else
    {Write-Verbose 'App pool $($appPool.Name) found'}
"@
        if($appPool.managedRuntimeVersion -notin '','v4.0'){@"
    Set-ItemProperty '$iispath' managedRuntimeVersion $($appPool.managedRuntimeVersion)
"@}
        $processModel = Get-ItemProperty $iispath processModel
        if($processModel.identityType -ne 'ApplicationPoolIdentity'){@"
    Set-ItemProperty '$iispath' processModel @{userName='$($processModel.userName)';identityType='$($processModel.identityType)'}
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
            $certbinding = Get-ChildItem IIS:\SslBindings |
                ? {$_.Sites -eq $name -and $protocol -eq 'https'} |
                % {@"
|% {
        try{`$_.AddSslCertificate('$($_.Thumbprint)','$($_.Store)')}
        catch{Write-Error "Unable to bind certificate to ${name}: `$_"; Write-Todo 'Bind certificate for $name'}
    }
"@}
            @"
    if(!(Get-WebBinding -Name '$name' -Protocol $protocol -IPAddress $ipAddress -Port $port -HostHeader '$hostHeader'))
    {@{
        Name       = '$name'
        Protocol   = '$protocol'
        IPAddress  = '$ipAddress'
        Port       = '$port'
        HostHeader = '$hostHeader'
    } |% {New-WebBinding @_} $certbinding }
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

function Get-LocationConfigPaths([string]$xpath)
{
    Select-Xml "/configuration/location[system.webServer/$xpath]/@path" (Get-WebConfigFile) |% {$_.Node.Value}
}

function Export-WebApplications
{
    $sitepath = @{}
    Get-Website |% {$sitepath[$_.Name]=$_.PhysicalPath}
    [object[]]$webapps = Get-WebApplication
    $i,$max,$functions = 0,($webapps.Count/100.),@()
    foreach($webapp in $webapps)
    {
        $name,$site,$physicalpath,$pool =
            $webapp.path.Trim('/'),
            $webapp.GetParentElement()['name'],
            $webapp.PhysicalPath,
            $webapp.applicationPool
        $iispath = "IIS:\Sites\$site\$name"
        if(!$physicalpath)
        {
            Write-Warning "Physical path for $iispath isn't accessible. Will have to guess. Try restarting PowerShell if this is failing for all apps."
            $physicalpath = "$($sitepath[$site])\$name"
            if(!(Test-Path $physicalpath -PathType Container))
            { Write-Error "Guessed physical path for $iispath ($physicalpath) not found. Manual fix required." }
        }
        $funcname = "Import-WebApplication_$($site -replace '\W+','')_$($name -replace '\W+','')"
        $functions += $funcname
        @"

function $funcname
{
    [CmdletBinding(SupportsShouldProcess=`$true,ConfirmImpact="High")] Param()
    if(!(`$PSCmdlet.ShouldProcess('$site web application: $name','import'))){return}
"@
        $local:PSDefaultParameterValues = @{
            'Get-WebConfiguration:PSPath'           = 'MACHINE/WEBROOT/APPHOST'
            'Get-WebConfiguration:Location'         = "$site/$name"
            'Get-WebConfigurationProperty:PSPath'   = 'MACHINE/WEBROOT/APPHOST'
            'Get-WebConfigurationProperty:Location' = "$site/$name"
        }
        $cfgcontext = "-PSPath MACHINE/WEBROOT/APPHOST -Location '$site/$name'"
        Write-Progress 'Exporting web applications' $iispath -Current $pool -Percent ($i/$max)
        @"
    Write-Progress 'Importing web applications' '$iispath' -Current '$pool' -Percent $([int]($i++/$max))
    if(!(Get-WebApplication '$name' -Site '$site'))
    {@{
        Name            = '$name'
        Site            = '$site'
        PhysicalPath    = '$physicalpath'
        ApplicationPool = '$pool'
    } |% {New-WebApplication @_}}
    else
    {Write-Verbose 'Web application $iispath found'}
"@
        Select-Xml "/configuration/location[@path='$site/$name']/system.webServer" (Get-WebConfigFile) |
            % {$_.Node.SelectNodes('*')} -pv cfg |
            % {
                if($_.LocalName -ne 'security') {"The $($_.LocalName) may be customized for $iispath"}
                else
                {
                    if($cfg.access){[psobject]@{
                        Filter = 'system.webServer/security/access'
                        Name   = 'SslFlags'
                        Value  = $_.access.sslFlags
                    }}
                    $cfg.SelectNodes('authentication/*') |
                        % {
                            if($_.userName){"Set $iispath username to $($_.userName)"}
                            if($_.InnerXml){"Configure $iispath $($_.LocalName) for $($_.InnerXml -replace '(?m)^\s+|[\r\n]+','')"}
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
    catch{Write-Todo "Set $iispath $($_.Filter) $($_.Name) to '$($_.Value)'"}
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
Import-Certificates
Import-WebAppPools
Import-Websites
Import-WebApplications
"@
}

function Export-WebConfiguration
{
    if(!(Test-Administrator)) {throw 'This script must be run as administrator.'}
    Export-Header
    Export-Certificates
    Export-GlobalModulesCheck
    Export-WebAppPools
    Export-Websites
    Export-WebApplications
    Export-Footer
}

Export-WebConfiguration |Out-File $Path utf8
