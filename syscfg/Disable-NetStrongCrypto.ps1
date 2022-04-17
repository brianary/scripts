<#
.SYNOPSIS
Disable strong crypto for .NET 3.5 & 4.5.

.LINK
https://docs.microsoft.com/en-us/security-updates/SecurityAdvisories/2015/2960358#suggested-actions
#>

#Requires -RunAsAdministrator
[CmdletBinding()][OutputType([void])] Param()

function Disable-SchUseStrongCrypto($path)
{
    if(Get-ItemProperty $path SchUseStrongCrypto -ErrorAction SilentlyContinue)
    {
        Write-Verbose "$path\SchUseStrongCrypto was $(Get-ItemPropertyValue $path SchUseStrongCrypto)"
        Set-ItemProperty $path SchUseStrongCrypto 0
    }
    else
    {
        Write-Verbose "$path\SchUseStrongCrypto was not set"
        New-ItemProperty $path SchUseStrongCrypto -Value 0 -PropertyType DWORD
    }
}

foreach($version in 'v2.0.50727','v4.0.30319')
{
    Disable-SchUseStrongCrypto HKLM:\SOFTWARE\Microsoft\.NETFramework\$version

    if(Test-Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\$version)
    {
        Disable-SchUseStrongCrypto HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\$version
    }
}
