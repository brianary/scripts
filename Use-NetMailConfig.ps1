<#
.Synopsis
    Use .NET configuration to set defaults for Send-MailMessage.

.Description

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

.Parameter Scope
	The scope to create the defaults in.

.Parameter Private
	Indicates the defaults should not be visible to child scopes.

.Component
    System.Configuration

.Link
	Add-ScopeLevel.ps1

.Link
	Set-ParameterDefault.ps1

.Link
    Send-MailMessage

.Example
    Use-NetMailConfig.ps1

    Sets Send-MailMessage defaults for From, SmtpServer, and UseSsl to
    values from the ConfigurationManager.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
[string] $Scope = 'Local',
[switch] $Private
)
try{[void][Configuration.ConfigurationManager]}catch{Add-Type -as System.Configuration}
$Scope = Add-ScopeLevel.ps1 $Scope
$sv = if($Private) {@{Scope=$Scope;Option='Private'}} else {@{Scope=$Scope}}
$smtp = [Configuration.ConfigurationManager]::GetSection('system.net/mailSettings/smtp')
Set-ParameterDefault.ps1 Send-MailMessage From $smtp.From @sv
if($smtp.DeliveryMethod -eq 'Network')
{
	Set-ParameterDefault.ps1 Send-MailMessage SmtpServer $smtp.Network.Host @sv
	Set-ParameterDefault.ps1 Send-MailMessage UseSsl $smtp.Network.EnableSsl @sv
}
Set-Variable PSEmailServer $smtp.Network.Host @sv
