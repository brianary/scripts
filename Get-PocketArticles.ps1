<#
.SYNOPSIS
Retrieves a list of saved articles from a Pocket account.

.OUTPUTS
System.Management.Automation.PSObject containing article details.
See https://getpocket.com/developer/docs/v3/retrieve for fields.

.NOTES
You'll need a "consumer key" (API key; see the link below to "create new app").
You'll be prompted for that, and to authorize it to your account.

You'll also need to have a registered secret vault to store the consumer key.

Register-SecretVault Microsoft.PowerShell.SecretStore -name $VaultName [-DefaultVault]

You can control whether the vault prompts for a password using Set-SecretStoreConfiguration

.LINK
https://getpocket.com/developer/

.LINK
https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/

.LINK
Set-ParameterDefault.ps1

.LINK
ConvertTo-EpochTime.ps1

.LINK
Remove-NullValues.ps1

.EXAMPLE
Get-PocketArticles.ps1 2020-02-15 2021-03-01 -State Archive -Tag Programming -Sort Newest |Format-Table -Auto

item_id    resolved_id given_url                                                                             given_title                                                                 favorite status time_added time_updated time_read  time_favorited
-------    ----------- ---------                                                                             -----------                                                                 -------- ------ ---------- ------------ ---------  --------------
2713538930 2713538930  https://dev.to/thementor/i-run-powershell-on-android-and-so-can-you-458k              I run PowerShell on Android and so can you !! - DEV Community               1        1      1610230461 1610432554   1610430179 1610432553
3002666222 3002666222  https://www.theregister.com/2020/06/01/linux_5_7/                                     80-characters-per-line limits should be terminal, says Linux kernel chief L 0        1      1609706654 1609781229   1609781227 0
3195903579 3195903579  https://devblogs.microsoft.com/powershell/announcing-powershell-crescendo-preview-1/  Announcing PowerShell Crescendo Preview.1 | PowerShell                      0        1      1607526051 1608436421   1608436415 0
3044493651 3044493651  https://www.compositional-it.com/news-blog/5-features-that-c-has-that-f-doesnt-have/  5 Features C# Has That F# Doesn't Have! | Compositional IT                  0        1      1594439301 1594500813   1594500812 0
2908050151 2908050151  https://thesharperdev.com/examples-using-httpclient-in-fsharp/                        Examples Using HttpClient in F# – The Sharper Dev                           0        1      1583616769 1583616987   1583616986 0
2907176185 2907176185  https://voiceofthedba.com/2020/03/06/the-developer-arguments-for-stored-procedures/   The Developer Arguments for Stored Procedures                               0        1      1583519345 1583616940   1583616940 0
2903715421 2903715421  https://khalidabuhakmeh.com/upgraded-dotnet-console-experience                        Upgrade Your .NET Console App Experience | Khalid Abuhakmeh                 0        1      1583440478 1583715611   1583715610 0
1526616723 1526616723  https://support.google.com/maps/answer/7047426?                                       Find and share places using plus codes                                      0        1      1565309293 1610746653   1565642230 0
#>

#Requires -Version 3
#Requires -Modules Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretStore
[CmdletBinding(SupportsShouldProcess=$true)][OutputType([psobject])] Param(
# Return articles newer than this time.
[Parameter(Position=1,Mandatory=$true)][datetime] $After,
# Return articles older than this time.
[Parameter(Position=2,Mandatory=$true)][datetime] $Before,
# Return articles containing this search term.
[Parameter(Position=3)][string] $Search,
# Return articles from this domain.
[string] $Domain,
# Return articles with this read/archived/either status.
[ValidateSet('Unread','Archive','All')][string] $State = 'Unread',
# Return articles with this tag.
[string] $Tag,
# Specifies a method for sorting returned articles.
[ValidateSet('Newest','Oldest','Title','Site')][string] $Sort,
# Return only video, image, or text articles as specified.
[ValidateSet('Article','Video','Image')][string] $ContentType,
<#
The name of the secret vault to retrieve the Pocket API consumer key from.
By default, the default vault is used.
#>
[string] $Vault,
# Return only favorite articles.
[switch] $Favorite,
# Return full article details.
[switch] $Detailed
)
Set-ParameterDefault.ps1 Invoke-RestMethod Method Post
Set-ParameterDefault.ps1 Invoke-RestMethod ContentType application/json
Set-ParameterDefault.ps1 Invoke-RestMethod Headers @{'X-Accept'='application/json'}
$consumerKey = try{(New-Object PSCredential PocketApiConsumerKey,( $Vault ?
	(Get-Secret PocketApiConsumerKey -Vault $Vault -ErrorAction SilentlyContinue) :
	(Get-Secret PocketApiConsumerKey -ErrorAction SilentlyContinue) )).GetNetworkCredential().Password}
	catch{}
if(!$consumerKey)
{
	$consumerKey = Get-Credential PocketApiConsumerKey -Message 'Pocket API consumer key'
	$VaultOrDefault = if($Vault) {@{Vault=$Vault}} else {@{}}
	Set-Secret PocketApiConsumerKey $consumerKey.Password @VaultOrDefault
	$consumerKey = $consumerKey.GetNetworkCredential().Password
}
$tokenfile = Join-Path ~ .pocket
$token =
	if(Test-Path $tokenfile -Type Leaf)
	{
		(New-Object pscredential pocket,(Get-Content $tokenfile |ConvertTo-SecureString)).GetNetworkCredential().Password
	}
	else
	{
		$redirectUri = 'https://webcoder.info/auth-success.html'
		$code = @{consumer_key=$consumerKey;redirect_uri=$redirectUri} |
			ConvertTo-Json -Compress |
			Invoke-RestMethod https://getpocket.com/v3/oauth/request -ContentType application/json |
			ForEach-Object code
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
$articles = @{
	consumer_key = $consumerKey
	access_token = $token
	state        = $State.ToLower()
	favorite     = if($Favorite) {1} else {$null};
	tag          = $Tag
	contentType  = if($ContentType) {$ContentType.ToLower()};
	sort         = if($Sort) {$Sort.ToLower()};
	detailType   = if($Detailed) {'complete'} else {'simple'};
	search       = $Search
	domain       = $Domain
	since        = ConvertTo-EpochTime.ps1 $After
} |
	Remove-NullValues.ps1 |
	ConvertTo-Json -Compress |
	Invoke-RestMethod https://getpocket.com/v3/get
if($articles -and $articles.list)
{
	$articles.list.PSObject.Properties.Value |Where-Object time_read -lt (ConvertTo-EpochTime.ps1 $Before)
}
