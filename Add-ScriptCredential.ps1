<#
.Synopsis
	Serializes a an encrypted credential to a PowerShell script using 32-byte random key file.

.Parameter Path
	The script path to add the serialized credential to.

.Parameter Name
	The variable name to assign the credential to within the script.

.Parameter Credential
	The credential to serialize.

.Parameter KeyFile
	The key file to use, which will be generated and encrypted if it doesn't exist.

.Inputs
	System.Management.Automation.PSCredential containing a credential to serialize.

.Link
	ConvertTo-PowerShell.ps1

.Example
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $Path,
[Parameter(Position=1,Mandatory=$true)][ValidatePattern('\w+')][string] $Name,
[Parameter(Position=2,Mandatory=$true,ValueFromPipeline=$true)][PSCredential] $Credential,
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
