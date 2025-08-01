# working on https://github.com/brianary/scripts/issues/71

# Set up TinyOAuth1.dll
# see https://github.com/johot/TinyOAuth1
using namespace TinyOAuth1
Add-NugetPackage.ps1 TinyOAuth1 TinyOAuth

$ckey = Get-Secret InstapaperAPIKey

# check https://www.instapaper.com/api
# a Postman example is at https://www.postman.com/codecharm/alanmcbee/documentation/9gan9mx/instapaper
# an example implementation is at https://metacpan.org/dist/WebService-Instapaper/source/lib/WebService/Instapaper.pm
# an example implementation is at https://github.com/rsgalloway/instapaper/blob/master/instapaper.py
# Set up the basic config parameters
$config = New-Object TinyOAuthConfig -Property @{
    AccessTokenUrl    = "https://www.instapaper.com/api/1/oauth/access_token"
    #AuthorizeTokenUrl = "https://www.instapaper.com/api/1/oauth/authorize" # ?
    #RequestTokenUrl   = "https://www.instapaper.com/api/1/oauth/requestToken" # ?
    ConsumerKey       = $ckey.UserName
    ConsumerSecret    = $ckey.GetNetworkCredential().Password
}

# Use the library
$tinyOAuth = New-Object TinyOAuth $config
$token = $tinyOAuth.GetRequestTokenAsync().GetAwaiter().GetResult()
if(!$token -or !$token.RequestToken) {throw 'No token was returned'}
$tinyOAuth.GetAuthorizationHeaderValue($token.RequestToken, $token.RequestTokenSecret,
   'https://www.instapaper.com/api/1/folders/list', 'GET')

# Get the request token and request token secret
$requestTokenInfo = $tinyOAuth.GetRequestTokenAsync().GetAwaiter().GetResult()

# Construct the authorization url
$authorizationUrl = $tinyOAuth.GetAuthorizationUrl($requestTokenInfo.RequestToken)

# *** You will need to implement these methods yourself ***
Start-Process $authorizationUrl
#$verificationCode = Read-Host

# *** Important: Do not run this code before visiting and completing the authorization url ***
#$accessTokenInfo = tinyOAuth.GetAccessTokenAsync($requestTokenInfo.RequestToken, $requestTokenInfo.RequestTokenSecret, $verificationCode).GetAwaiter().GetResult()
