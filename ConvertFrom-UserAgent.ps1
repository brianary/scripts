<#
.Synopsis
    Parse an HTTP User-Agent string.

.Parameter UserAgent
    An HTTP User-Agent string header value to parse.

.Inputs
    An object with a UserAgent property.

.Outputs
    System.Web.HttpBrowserCapabilities parsed from the HTTP User-Agent string.

.Component
    System.Web

.Link
    https://docs.microsoft.com/dotnet/api/system.web.httpbrowsercapabilities

.Link
    https://stackoverflow.com/a/3891902

.Example
    ConvertFrom-UserAgent.ps1 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36'

    UseOptimizedCacheKey                      : True
    Capabilities                              : {canInitiateVoiceCall, jscriptversion, supportsInputIStyle, type...}
    Adapters                                  : {}
    HtmlTextWriter                            :
    Id                                        : chrome
    Browsers                                  : {default, mozilla, webkit, chrome}
    ClrVersion                                :
    Type                                      : Chrome68
    Browser                                   : Chrome
    Version                                   : 68.0
    MajorVersion                              : 68
    MinorVersionString                        : 0
    MinorVersion                              : 0
    Platform                                  : WinNT
    TagWriter                                 : System.Web.UI.HtmlTextWriter
    EcmaScriptVersion                         : 3.0
    MSDomVersion                              : 0.0
    W3CDomVersion                             : 1.0
    Beta                                      : False
    Crawler                                   : False
    AOL                                       : False
    Win16                                     : False
    Win32                                     : True
    Frames                                    : True
    RequiresControlStateInSession             : False
    Tables                                    : True
    Cookies                                   : True
    VBScript                                  : False
    JavaScript                                : True
    JavaApplets                               : True
    JScriptVersion                            : 0.0
    ActiveXControls                           : False
    BackgroundSounds                          : False
    CDF                                       : False
    MobileDeviceManufacturer                  : Unknown
    MobileDeviceModel                         : Unknown
    GatewayVersion                            : None
    GatewayMajorVersion                       : 0
    GatewayMinorVersion                       : 0
    PreferredRenderingType                    : html32
    PreferredRequestEncoding                  :
    PreferredResponseEncoding                 :
    PreferredRenderingMime                    : text/html
    PreferredImageMime                        : image/gif
    ScreenCharactersWidth                     : 80
    ScreenCharactersHeight                    : 40
    ScreenPixelsWidth                         : 640
    ScreenPixelsHeight                        : 480
    ScreenBitDepth                            : 8
    IsColor                                   : True
    InputType                                 : keyboard
    NumberOfSoftkeys                          : 0
    MaximumSoftkeyLabelLength                 : 5
    CanInitiateVoiceCall                      : False
    CanSendMail                               : True
    HasBackButton                             : True
    RendersWmlDoAcceptsInline                 : True
    RendersWmlSelectsAsMenuCards              : False
    RendersBreaksAfterWmlAnchor               : False
    RendersBreaksAfterWmlInput                : False
    RendersBreakBeforeWmlSelectAndInput       : False
    RequiresPhoneNumbersAsPlainText           : False
    RequiresUrlEncodedPostfieldValues         : False
    RequiredMetaTagNameValue                  :
    RendersBreaksAfterHtmlLists               : True
    RequiresUniqueHtmlInputNames              : False
    RequiresUniqueHtmlCheckboxNames           : False
    SupportsCss                               : True
    HidesRightAlignedMultiselectScrollbars    : False
    IsMobileDevice                            : False
    RequiresAttributeColonSubstitution        : False
    CanRenderOneventAndPrevElementsTogether   : True
    CanRenderInputAndSelectElementsTogether   : True
    CanRenderAfterInputOrSelectElement        : True
    CanRenderPostBackCards                    : True
    CanRenderMixedSelects                     : True
    CanCombineFormsInDeck                     : True
    CanRenderSetvarZeroWithMultiSelectionList : True
    SupportsImageSubmit                       : True
    RequiresUniqueFilePathSuffix              : False
    RequiresNoBreakInFormatting               : False
    RequiresLeadingPageBreak                  : False
    SupportsSelectMultiple                    : True
    SupportsBold                              : True
    SupportsItalic                            : True
    SupportsFontSize                          : True
    SupportsFontName                          : True
    SupportsFontColor                         : True
    SupportsBodyColor                         : True
    SupportsDivAlign                          : True
    SupportsDivNoWrap                         : False
    RequiresContentTypeMetaTag                : False
    RequiresDBCSCharacter                     : False
    RequiresHtmlAdaptiveErrorReporting        : False
    RequiresOutputOptimization                : False
    SupportsAccesskeyAttribute                : True
    SupportsInputIStyle                       : False
    SupportsInputMode                         : False
    SupportsIModeSymbols                      : False
    SupportsJPhoneSymbols                     : False
    SupportsJPhoneMultiMediaAttributes        : False
    MaximumRenderedPageSize                   : 300000
    RequiresSpecialViewStateEncoding          : False
    SupportsQueryStringInFormAction           : True
    SupportsCacheControlMetaTag               : True
    SupportsUncheck                           : True
    CanRenderEmptySelects                     : True
    SupportsRedirectWithCookie                : True
    SupportsEmptyStringInCookieValue          : True
    DefaultSubmitButtonLimit                  : 1
    SupportsXmlHttp                           : True
    SupportsCallback                          : True
    MaximumHrefLength                         : 10000
#>

#Requires -Version 3
[CmdletBinding()][OutputType([Web.HttpBrowserCapabilities])] Param(
[Parameter(Mandatory=$true,Position=0,ValueFromPipelineByPropertyName=$true)][string]$UserAgent
)
Begin
{
    try{[void][Web.Configuration.BrowserCapabilitiesFactory]}catch{Add-Type -AN System.Web}
    $factory = New-Object Web.Configuration.BrowserCapabilitiesFactory
}
Process
{
    $browser = New-Object Web.HttpBrowserCapabilities -Property @{Capabilities=@{''=$UserAgent}}
    $factory.ConfigureBrowserCapabilities(@{},$browser)
    $browser
}
