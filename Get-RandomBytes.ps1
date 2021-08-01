<#
.Synopsis
    Returns random bytes.

.Outputs
    System.Byte[] of random bytes.

.Parameter Count
    The number of random bytes to return.

.Link
	https://docs.microsoft.com/dotnet/api/system.security.cryptography.rngcryptoserviceprovider

.Example
    Get-RandomBytes.ps1 8

	103
	235
	194
	199
	151
	83
	240
	152
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][int] $Count
)
[byte[]] $value = New-Object byte[] $Count
$rng = New-Object Security.Cryptography.RNGCryptoServiceProvider
$rng.GetBytes($value)
$rng.Dispose(); $rng = $null
return,$value
