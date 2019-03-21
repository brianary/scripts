<#
.Synopsis
    Gets the physical path on disk of a certificate.

.Parameter Certificate
    The X509Certificate2 to look up the path for.

.Inputs
    System.Security.Cryptography.X509Certificates.X509Certificate2 to find the private key file for.

.Outputs
    System.String of the path to the private key file (if found).

.Link
    Find-Certificate.ps1

.Link
    Format-Certificate.ps1

.Link
    https://github.com/MicrosoftArchive/clrsecurity/blob/master/Security.Cryptography/src/X509Certificates/X509Certificate2ExtensionMethods.cs#L58

.Example
    Find-Certificate.ps1 localhost FindBySubjectName My LocalMachine |Get-CertificatePath.ps1

    C:\ProgramData\Microsoft\crypto\rsa\machinekeys\abd662b361941f26a1173357adb3c12d_b4d34fe9-d85e-45e3-83dd-a52fa93c8551
#>

#Requires -Version 3
#TODO: Require version 4 to get access to Get-ChildItem -Directory switch param
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
[System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate
)
Begin
{
    function Find-PrivateKeyFile([Parameter(Position=0,Mandatory=$true)][string]$filename)
    { # flail wildly
        Write-Warning "Searching more desperately for the certificate file."
        Get-ChildItem $env:USERPROFILE\.. |
            ? {$_ -is [IO.DirectoryInfo]} |
            % {"$($_.FullName)\AppData\Roaming\Microsoft\Crypto\RSA"} |
            ? {Test-Path $_ -PathType Container} |
            Get-ChildItem |
            ? {$_ -is [IO.DirectoryInfo]} |
            % {Join-Path $_.FullName $filename} |
            ? {Test-Path $_ -PathType Leaf}
    }
    function Get-PrivateKeyFile([Parameter(Position=0,Mandatory=$true)][string]$filename)
    {
        $path = "$env:ProgramData\Microsoft\crypto\rsa\machinekeys\$file"
        if(!(Test-Path $path -PathType Leaf))
        {
            Write-Verbose "Machine key path not found: $path"
            $sid = ([Security.Principal.NTAccount]$env:USERNAME).Translate([Security.Principal.SecurityIdentifier]).Value
            $path = "$env:APPDATA\Microsoft\Crypto\RSA\$sid\$file"
            if(!(Test-Path $path -PathType Leaf)) {$path = Find-PrivateKeyFile $file}
            if(!(Test-Path $path -PathType Leaf)) {throw "Could not find certificate path: $path"}
        }
        Write-Verbose "Certificate path: $path"
        $path
    }
    function Use-CryptoApi
    {try{[void][CryptoApi]}catch{Add-Type -TypeDefinition @'
using System;
using System.Diagnostics.CodeAnalysis;
using System.Runtime.ConstrainedExecution;
using System.Runtime.InteropServices;
using System.Security;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;
using System.Security.Permissions;
using Microsoft.Win32.SafeHandles;
public static class CryptoApi
{
    [SecurityPermission(SecurityAction.LinkDemand, UnmanagedCode = true)]
    public sealed class SafeCertContextHandle : SafeHandleZeroOrMinusOneIsInvalid
    {
        private SafeCertContextHandle() : base(true) {}
        [DllImport("crypt32.dll")]
        [ReliabilityContract(Consistency.WillNotCorruptState, Cer.Success)]
        [SuppressMessage("Microsoft.Design", "CA1060:MovePInvokesToNativeMethodsClass", Justification = "SafeHandle release method")]
        [SuppressUnmanagedCodeSecurity]
        [return: MarshalAs(UnmanagedType.Bool)]
        private static extern bool CertFreeCertificateContext(IntPtr pCertContext);
        protected override bool ReleaseHandle() {return CertFreeCertificateContext(handle);}
    }
    [DllImport("crypt32.dll")]
    internal static extern SafeCertContextHandle CertDuplicateCertificateContext(IntPtr certContext);       // CERT_CONTEXT *
    [DllImport("crypt32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    internal static extern bool CryptAcquireCertificatePrivateKey(SafeCertContextHandle pCert,
                                                                  uint dwFlags,
                                                                  IntPtr pvReserved,        // void *
                                                                  [Out] out SafeNCryptKeyHandle phCryptProvOrNCryptKey,
                                                                  [Out] out int dwKeySpec,
                                                                  [Out, MarshalAs(UnmanagedType.Bool)] out bool pfCallerFreeProvOrNCryptKey);
    [SecurityCritical]
    [SecurityPermission(SecurityAction.LinkDemand, UnmanagedCode = true)]
    public static string GetCngUniqueKeyContainerName(X509Certificate2 certificate)
    {
        bool freeKey = true;
        int keySpec = 0;
        SafeNCryptKeyHandle privateKey = null;
        CryptAcquireCertificatePrivateKey(CertDuplicateCertificateContext(certificate.Handle),
                                          0x00040000, // AcquireOnlyNCryptKeys
                                          IntPtr.Zero, out privateKey, out keySpec, out freeKey);
        return CngKey.Open(privateKey, CngKeyHandleOpenOptions.None).UniqueName;
    }
}
'@}}
    function Get-CngPrivateKeyFileName([Parameter(Position=0,Mandatory=$true)]
        [System.Security.Cryptography.X509Certificates.X509Certificate2]$cert)
    {
        Use-CryptoApi
        try {[CryptoApi]::GetCngUniqueKeyContainerName($cert)}
        catch [Management.Automation.MethodInvocationException]
        {
            if(!(Test-Administrator.ps1)) {Write-Error "Not running as admin. Finding private key details may fail."}
            throw
        }
    }
    function Get-CngPrivateKeyFile([Parameter(Position=0,Mandatory=$true)][string]$filename)
    {
        $path = "$env:ProgramData\Microsoft\crypto\Keys\$file"
        if(!(Test-Path $path -PathType Leaf))
        {
            Write-Verbose "CNG machine key path not found: $path"
            $path = "$env:APPDATA\Microsoft\Crypto\Keys\$file"
            if(!(Test-Path $path -PathType Leaf)) {throw "Could not find CNG certificate path: $path"}
        }
        Write-Verbose "CNG certificate path: $path"
        $path
    }
}
Process
{
    [bool]$hasPath = $Certificate |Get-Member Path -MemberType NoteProperty
    if($hasPath -and $Certificate.Path) {$Certificate.Path}
    else
    {
        $certname = Format-Certificate.ps1 $Certificate
        if(!$Certificate.HasPrivateKey) { Write-Error "No private key for $certname"; return }
        if($Certificate.PrivateKey)
        {
            $file = $Certificate.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName
            if(!$file) { Write-Error "No private key filename for $certname"; return }
            Write-Verbose "Certificate file: $file"
            $path = Get-PrivateKeyFile $file
        }
        else
        {
            $file = Get-CngPrivateKeyFileName $Certificate
            $path = Get-CngPrivateKeyFile $file
        }
        if($hasPath) {$Certificate.Path = $path}
        else {Add-Member -InputObject $Certificate -MemberType NoteProperty -Name Path -Value $path}
        $path
    }
}
