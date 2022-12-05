<#
.SYNOPSIS
Use .NET configuration to set defaults for Send-MailMessage.

.DESCRIPTION

The configuration system provides a place to set email defaults:

<system.net>
  <mailSettings>
    <smtp from="source@example.org" deliveryMethod="network">
      <network host="mail.example.org" enableSsl="true" />
    </smtp>
  </mailSettings>
</system.net>

The values for Send-MailMessage's From, SmtpServer, and UseSsl will be
taken from whatever is set in the machine.config (or more localized config).

.FUNCTIONALITY
Configuration

.COMPONENT
System.Configuration

.LINK
Add-ScopeLevel.ps1

.LINK
Set-ParameterDefault.ps1

.LINK
Send-MailMessage

.EXAMPLE
Use-NetMailConfig.ps1

Sets Send-MailMessage defaults for From, SmtpServer, and UseSsl to
values from the ConfigurationManager.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
# The scope to create the defaults in.
[string] $Scope = 'Local',
# Indicates the defaults should not be visible to child scopes.
[switch] $Private
)

$Scope = Add-ScopeLevel.ps1 $Scope
$sv = if($Private) {@{Scope=$Scope;Option='Private'}} else {@{Scope=$Scope}}

if($PSVersionTable.PSEdition -eq 'Core')
{ # from .NET (Core), run from .NET Framework, which has a machine.config to parse
	$values = Invoke-WindowsPowerShell.ps1 { Use-NetMailConfig.ps1; $PSDefaultParameterValues }
	$values.Keys |ForEach-Object {Set-ParameterDefault.ps1 Send-MailMessage `
		($_ -replace '\ASend-MailMessage:') ($values[$_]) @sv}
	Set-Variable PSEmailServer ($values['Send-MailMessage:SmtpServer']) @sv
}
else
{
	try{[void][Configuration.ConfigurationManager]}catch{Add-Type -as System.Configuration}
	$smtp = [Configuration.ConfigurationManager]::GetSection('system.net/mailSettings/smtp')
	if($smtp.From) { Set-ParameterDefault.ps1 Send-MailMessage From $smtp.From @sv }
	if($smtp.DeliveryMethod -eq 'Network' -and $smtp.Network)
	{
		if($smtp.Network.Host) {Set-ParameterDefault.ps1 Send-MailMessage SmtpServer $smtp.Network.Host @sv}
		if($smtp.Network.EnableSsl) {Set-ParameterDefault.ps1 Send-MailMessage UseSsl $smtp.Network.EnableSsl @sv}
	}
	else
	{
		Write-Verbose 'Delivery method is not configured as Network'
	}
	Set-Variable PSEmailServer $smtp.Network.Host @sv
}
