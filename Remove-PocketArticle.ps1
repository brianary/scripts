<#
.SYNOPSIS
Removes an article from a Pocket account.
#>


#Requires -Version 3
#Requires -Modules Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretStore
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText','',
Justification='This value has to be converted to text to be sent in a text body.')]
[CmdletBinding(SupportsShouldProcess=$true)][OutputType([psobject])] Param(
# The Pocket-assigned article ID.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('item_id')][long] $ItemId,
<#
The name of the secret vault to retrieve the Pocket API consumer key from.
By default, the default vault is used.
#>
[string] $Vault
)
Process
{
	Set-ParameterDefault.ps1 Invoke-RestMethod Method Post
	Set-ParameterDefault.ps1 Invoke-RestMethod ContentType application/json
	Set-ParameterDefault.ps1 Invoke-RestMethod Headers @{'X-Accept'='application/json'}
	$consumerKey = ( $Vault ?
		(Get-Secret PocketApiConsumerKey -Vault $Vault -ErrorAction Ignore) :
		(Get-Secret PocketApiConsumerKey -ErrorAction Ignore) ) |
		ConvertFrom-SecureString -AsPlainText -ErrorAction Ignore
	if(!$consumerKey)
	{
		$consumerKey = Get-Credential PocketApiConsumerKey -Message 'Pocket API consumer key'
		$VaultOrDefault = if($Vault) {@{Vault=$Vault}} else {@{}}
		Set-Secret PocketApiConsumerKey $consumerKey.Password @VaultOrDefault
		$consumerKey = $consumerKey.Password |ConvertFrom-SecureString -AsPlainText
	}
	$tokenfile = Join-Path ~ .pocket
	$token =
		if(Test-Path $tokenfile -Type Leaf)
		{
			Get-Content $tokenfile |ConvertTo-SecureString |ConvertFrom-SecureString -AsPlainText
		}
		else
		{
			$redirectUri = 'https://webcoder.info/auth-success.html'
			$code = @{consumer_key=$consumerKey;redirect_uri=$redirectUri} |
				ConvertTo-Json -Compress |
				Invoke-RestMethod https://getpocket.com/v3/oauth/request -ContentType application/json |
				Select-Object -ExpandProperty code
			Start-Process "https://getpocket.com/auth/authorize?request_token=$code&redirect_uri=$([uri]::EscapeDataString($redirectUri))" -Wait
			if(!$PSCmdlet.ShouldContinue('Has the token been authorized?','Authorize')) {return}
			$code = @{consumer_key=$consumerKey;code=$code} |
				ConvertTo-Json -Compress |
				Invoke-RestMethod https://getpocket.com/v3/oauth/authorize -Method Post -ContentType application/json
			Write-Verbose "Authenticated token for $($code.username)"
			$code.access_token |ConvertTo-SecureString -AsPlainText -Force |ConvertFrom-SecureString |Out-File $tokenfile
			$code.access_token
		}
	Write-Verbose "Using key $consumerKey and token $token"
	Invoke-RestMethod ("https://getpocket.com/v3/send?actions={0}&access_token=$token&consumer_key=$consumerKey" -f
		([uri]::EscapeDataString(@"
[{"action": "delete", "item_id": "$ItemId"}]
"@)))
}
