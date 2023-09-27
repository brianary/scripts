<#
.SYNOPSIS
Retrieves a list of saved articles from a Pocket account.

.OUTPUTS
System.Management.Automation.PSObject containing article details.
* ItemId: The article ID.
* Title: The simplified article title.
* Url: The resolved URL.
* IsFavorite: True if favorited.
* IsArchived: True if archived.
* WordCount: The approximate number of words in the article.
* AddedAt: DateTime the article was added.
* ReadAt: DateTime the article was read.
* UpdatedAt: DateTime the article was last updated.
* Tags: Keywords associated with the article.
* Language: Linguistic culture of the article.
* ReadDuration: The approximate time to listen to the article.
* FullTitle: The original article title.
* FullUrl: The original article URL.
* Excerpt: A summary of the article.

.NOTES
You'll need a "consumer key" (API key; see the link below to "create new app").
You'll be prompted for that, and to authorize it to your account.

You'll also need to have a registered secret vault to store the consumer key.

Register-SecretVault Microsoft.PowerShell.SecretStore -name $VaultName [-DefaultVault]

You can control whether the vault prompts for a password using Set-SecretStoreConfiguration

.LINK
https://getpocket.com/developer/

.LINK
https://getpocket.com/developer/docs/v3/retrieve

.LINK
https://devblogs.microsoft.com/powershell/secretmanagement-and-secretstore-are-generally-available/

.LINK
Set-ParameterDefault.ps1

.LINK
ConvertTo-EpochTime.ps1

.LINK
Remove-NullValues.ps1

.EXAMPLE
Get-PocketArticles.ps1 2020-02-15 2021-03-01 -State Archive -Tag Programming -Sort Newest |Format-Table Title,WordCount,AddedAt -Auto

Title                                                                                         WordCount AddedAt
-----                                                                                         --------- -------
I run PowerShell on Android and so can you !!                                                       540 2021-01-09 22:14:21
80-characters-per-line limits should be terminal, says Linux kernel chief Linus Torvalds            476 2021-01-03 20:44:14
Scott Hanselman's 2021 Ultimate Developer and Power Users Tool List for Windows                    2201 2020-12-25 02:15:26
Announcing PowerShell Crescendo Preview.1                                                          1319 2020-12-09 15:00:51
Windows Terminal Preview 1.5 out with a host of new features, version 1.4 generally available       448 2020-11-12 03:42:00
5 Features C# Has That F# Doesn’t Have!                                                            1489 2020-07-11 03:48:21
#>

#Requires -Version 7
#Requires -Modules Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretStore
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText','',
Justification='This value has to be converted to text to be sent in a text body.')]
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
[switch] $Favorite
)
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
$articles = @{
	consumer_key = $consumerKey
	access_token = $token
	state        = $State.ToLower()
	favorite     = if($Favorite) {1} else {$null};
	tag          = $Tag
	contentType  = if($ContentType) {$ContentType.ToLower()};
	sort         = if($Sort) {$Sort.ToLower()};
	detailType   = 'complete'
	search       = $Search
	domain       = $Domain
	since        = ConvertTo-EpochTime.ps1 $After
} |
	Remove-NullValues.ps1 |
	ConvertTo-Json -Compress |
	Invoke-RestMethod https://getpocket.com/v3/get
${articles}?.{list}?.{PSObject}?.{Properties}?.Value |
	ForEach-Object {[pscustomobject]@{
		ItemId       = $_.item_id
		Title        = $_.resolved_title
		Url          = [uri]$_.resolved_url
		IsFavorite   = [bool]$_.favorite
		IsArchived   = [bool]$_.status
		WordCount    = [long]$_.word_count
		AddedAt      = ConvertFrom-EpochTime.ps1 $_.time_added
		ReadAt       = ConvertFrom-EpochTime.ps1 $_.time_read
		UpdatedAt    = ConvertFrom-EpochTime.ps1 $_.time_updated
		Tags         = @($_.{tags}?.{PSObject}?.{Properties}?.Name)
		#TODO: Image        = $_.{image}?.src
		Language     = Get-Culture $_.lang
		ReadDuration = [timespan]::FromSeconds($_.listen_duration_estimate)
		FullTitle    = $_.given_title
		FullUrl      = [uri]$_.given_url
		Excerpt      = $_.excerpt
	}} |
	Where-Object ReadAt -lt $Before
