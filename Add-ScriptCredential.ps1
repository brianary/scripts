<#
.SYNOPSIS
Serializes a an encrypted credential to a PowerShell script using 32-byte random key file.

.INPUTS
System.Management.Automation.PSCredential containing a credential to serialize.

.LINK
ConvertTo-PowerShell.ps1
#>

#Requires -Version 3
[CmdletBinding()] Param(
# The script path to add the serialized credential to.
[Parameter(Position=0,Mandatory=$true)][string] $Path,
# The variable name to assign the credential to within the script.
[ValidatePattern('\A\w+\z',ErrorMessage='An alphanumeric identifier is required')]
[Parameter(Position=1,Mandatory=$true)][string] $Name,
# The credential to serialize.
[Parameter(Position=2,Mandatory=$true,ValueFromPipeline=$true)][PSCredential] $Credential,
# The key file to use, which will be generated and encrypted if it doesn't exist.
[string] $KeyFile = '~/.pskey'
)
Begin
{
	$asbytes =
		if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=$true}}
		else {@{Encoding='Byte'}}
	function Register-PSKey
	{
		[byte[]] $key = Get-RandomBytes.ps1 32
		Set-Content $keyfile $key @asbytes
		$f = Get-Item $keyfile
		$f.Attributes = $f.Attributes -bor 'Hidden'
		$f.Encrypt()
		$f = $null
		$key
	}
	[byte[]] $key =
		if(!(Test-Path $keyfile -Type Leaf)) {Register-PSKey}
		else {Get-Content $keyfile -Force @asbytes}
	$keycmd = @"
`$asbytes =
	if((Get-Command Get-Content).Parameters.Encoding.ParameterType -eq [Text.Encoding]) {@{AsByteStream=`$true}}
	else {@{Encoding='Byte'}}
`$key = Get-Content '$keyfile' -Force @asbytes
"@
	if(!(Select-String ([regex]::Escape($keyfile)) $Path))
	{
		$keycmd |Add-Content $Path
	}
}
Process
{
	"Set-Variable '$Name' ($($Credential |ConvertTo-PowerShell.ps1 -KeyBytes $key))" |Add-Content $Path
}
