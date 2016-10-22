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

.Link
    Send-MailMessage

.Example
    Use-NetMailConfig.ps1

    Sets Send-MailMessage defaults for From, SmtpServer, and UseSsl to 
    values from the ConfigurationManager.
#>

try{[void][Configuration.ConfigurationManager]}catch{Add-Type -as System.Configuration}
$smtp = [Configuration.ConfigurationManager]::GetSection('system.net/mailSettings/smtp')
$value = @{
    'Send-MailMessage:From'       = $smtp.From
    'Send-MailMessage:SmtpServer' = $smtp.Network.Host
    'Send-MailMessage:UseSsl'     = $smtp.Network.EnableSsl
}
$defaults = Get-Variable -Scope 1 -Name PSDefaultParameterValues -EA SilentlyContinue
if($defaults) {$value.Keys |? {$value.$_ -and $defaults.Value.Contains($_)} |% {$defaults.Value.Remove($_)}; $defaults.Value += $value}
else {Set-Variable -Scope 1 -Name PSDefaultParameterValues -Value $value}
$server = Get-Variable -Scope 1 -Name PSEmailServer -EA SilentlyContinue
if($server) {$server.Value = $smtp.Network.Host}
else {$Global:PSEmailServer = $smtp.Network.Host}
