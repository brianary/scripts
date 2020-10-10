<#
.Synopsis
	Uses OpenSSH to generate a key and connect it to an ssh server.

.Parameter HostName
	The ssh server to connect to.

.Example
	Connect-SshKey.ps1 crowpi
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string] $HostName
)

if(!(Test-Path $env:USERPROFILE\.ssh\id_rsa.pub -Type Leaf) -or !((Get-Item $env:USERPROFILE\.ssh\id_rsa.pub).Length))
{
	Use-Command.ps1 ssh-keygen "$env:SystemRoot\system32\openssh\ssh-keygen.exe" -WindowsFeature 'OpenSSH.Client~~~~0.0.1.0'
	ssh-keygen
}
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub |ssh "$env:UserName@$HostName" 'cat >> .ssh/authorized_keys'
