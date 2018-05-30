<#
.Synopsis
    Sets the .NET Frameworks prior to 4.7.1 to inherit the system TLS settings.

.Description
    In environments where SSL3 or older TLS versions have been disabled, the
    hard-coded System.Net.ServicePointManager.SecurityProtocol value of
    Ssl3|Tls has to be manually overridden in code, which just moves the
    hard-coding problem around.

    Instead, these registry settings tell .NET to do the right thing.

.Parameter Undo
    Disables the settings, instead of enabling them.

.Link
    Set-ItemProperty

.Example
    Use-SystemCrypto.ps1

    Writes registry settings to inherit crypto settings.
#>

[CmdletBinding()] Param([switch]$Undo)
$value = if($Undo){0}else{1}
Set-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727' SystemDefaultTlsVersions $value -Type Dword
Set-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v2.0.50727' SchUseStrongCrypto $value -Type Dword
Set-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' SystemDefaultTlsVersions $value -Type Dword
Set-ItemProperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' SchUseStrongCrypto $value -Type Dword
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' SystemDefaultTlsVersions $value -Type Dword
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v2.0.50727' SchUseStrongCrypto $value -Type Dword
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' SystemDefaultTlsVersions $value -Type Dword
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' SchUseStrongCrypto $value -Type Dword
