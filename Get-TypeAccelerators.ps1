<#
.SYNOPSIS
Returns the list of PowerShell type accelerators.

.OUTPUTS
Collections.Generic.Dictionary[string,type]

.FUNCTIONALITY
PowerShell

.EXAMPLE
Get-TypeAccelerators.ps1


Alias                        Type                                                                Suffix
-----                        ----                                                                ------
Alias                        System.Management.Automation.AliasAttribute
AllowEmptyCollection         System.Management.Automation.AllowEmptyCollectionAttribute
AllowEmptyString             System.Management.Automation.AllowEmptyStringAttribute
AllowNull                    System.Management.Automation.AllowNullAttribute
ArgumentCompleter            System.Management.Automation.ArgumentCompleterAttribute
ArgumentCompletions          System.Management.Automation.ArgumentCompletionsAttribute
array                        System.Array
bool                         System.Boolean
byte                         System.Byte                                                         y
char                         System.Char
CmdletBinding                System.Management.Automation.CmdletBindingAttribute
datetime                     System.DateTime
decimal                      System.Decimal                                                      d
double                       System.Double
DscResource                  System.Management.Automation.DscResourceAttribute
ExperimentAction             System.Management.Automation.ExperimentAction
Experimental                 System.Management.Automation.ExperimentalAttribute
ExperimentalFeature          System.Management.Automation.ExperimentalFeature
float                        System.Single
single                       System.Single
guid                         System.Guid
hashtable                    System.Collections.Hashtable
int                          System.Int32
int32                        System.Int32
short                        System.Int16                                                        s
int16                        System.Int16                                                        s
long                         System.Int64                                                        l
int64                        System.Int64                                                        l
ciminstance                  Microsoft.Management.Infrastructure.CimInstance
cimclass                     Microsoft.Management.Infrastructure.CimClass
cimtype                      Microsoft.Management.Infrastructure.CimType
cimconverter                 Microsoft.Management.Infrastructure.CimConverter
IPEndpoint                   System.Net.IPEndPoint
NullString                   System.Management.Automation.Language.NullString
OutputType                   System.Management.Automation.OutputTypeAttribute
ObjectSecurity               System.Security.AccessControl.ObjectSecurity
ordered                      System.Collections.Specialized.OrderedDictionary
Parameter                    System.Management.Automation.ParameterAttribute
PhysicalAddress              System.Net.NetworkInformation.PhysicalAddress
pscredential                 System.Management.Automation.PSCredential
PSDefaultValue               System.Management.Automation.PSDefaultValueAttribute
pslistmodifier               System.Management.Automation.PSListModifier
psobject                     System.Management.Automation.PSObject
pscustomobject               System.Management.Automation.PSObject
psprimitivedictionary        System.Management.Automation.PSPrimitiveDictionary
ref                          System.Management.Automation.PSReference
PSTypeNameAttribute          System.Management.Automation.PSTypeNameAttribute
regex                        System.Text.RegularExpressions.Regex
DscProperty                  System.Management.Automation.DscPropertyAttribute
sbyte                        System.SByte                                                        uy
string                       System.String
SupportsWildcards            System.Management.Automation.SupportsWildcardsAttribute
switch                       System.Management.Automation.SwitchParameter
cultureinfo                  System.Globalization.CultureInfo
bigint                       System.Numerics.BigInteger                                          n
securestring                 System.Security.SecureString
timespan                     System.TimeSpan
ushort                       System.UInt16                                                       us
uint16                       System.UInt16                                                       us
uint                         System.UInt32                                                       u
uint32                       System.UInt32                                                       u
ulong                        System.UInt64                                                       ul
uint64                       System.UInt64                                                       ul
uri                          System.Uri
ValidateCount                System.Management.Automation.ValidateCountAttribute
ValidateDrive                System.Management.Automation.ValidateDriveAttribute
ValidateLength               System.Management.Automation.ValidateLengthAttribute
ValidateNotNull              System.Management.Automation.ValidateNotNullAttribute
ValidateNotNullOrEmpty       System.Management.Automation.ValidateNotNullOrEmptyAttribute
ValidatePattern              System.Management.Automation.ValidatePatternAttribute
ValidateRange                System.Management.Automation.ValidateRangeAttribute
ValidateScript               System.Management.Automation.ValidateScriptAttribute
ValidateSet                  System.Management.Automation.ValidateSetAttribute
ValidateTrustedData          System.Management.Automation.ValidateTrustedDataAttribute
ValidateUserDrive            System.Management.Automation.ValidateUserDriveAttribute
version                      System.Version
void                         System.Void
ipaddress                    System.Net.IPAddress
DscLocalConfigurationManager System.Management.Automation.DscLocalConfigurationManagerAttribute
WildcardPattern              System.Management.Automation.WildcardPattern
X509Certificate              System.Security.Cryptography.X509Certificates.X509Certificate
X500DistinguishedName        System.Security.Cryptography.X509Certificates.X500DistinguishedName
xml                          System.Xml.XmlDocument
CimSession                   Microsoft.Management.Infrastructure.CimSession
mailaddress                  System.Net.Mail.MailAddress
semver                       System.Management.Automation.SemanticVersion
adsi                         System.DirectoryServices.DirectoryEntry
adsisearcher                 System.DirectoryServices.DirectorySearcher
wmiclass                     System.Management.ManagementClass
wmi                          System.Management.ManagementObject
wmisearcher                  System.Management.ManagementObjectSearcher
scriptblock                  System.Management.Automation.ScriptBlock
pspropertyexpression         Microsoft.PowerShell.Commands.PSPropertyExpression
psvariable                   System.Management.Automation.PSVariable
type                         System.Type
psmoduleinfo                 System.Management.Automation.PSModuleInfo
powershell                   System.Management.Automation.PowerShell
runspacefactory              System.Management.Automation.Runspaces.RunspaceFactory
runspace                     System.Management.Automation.Runspaces.Runspace
initialsessionstate          System.Management.Automation.Runspaces.InitialSessionState
psscriptmethod               System.Management.Automation.PSScriptMethod
psscriptproperty             System.Management.Automation.PSScriptProperty
psnoteproperty               System.Management.Automation.PSNoteProperty
psaliasproperty              System.Management.Automation.PSAliasProperty
psvariableproperty           System.Management.Automation.PSVariableProperty
#>

[CmdletBinding()][OutputType([Collections.Generic.Dictionary[string,type]])] Param(
[ValidateSet('Alias','Type','TypeName')][string] $DictionaryKey
)
if($DictionaryKey -eq 'Alias')
{
	return [PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get
}
elseif($DictionaryKey -eq 'Type')
{
	$dictionary = @{}
	([PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get).GetEnumerator() |
		ForEach-Object {$dictionary[$_.Value] = $_.Key}
	return $dictionary
}
elseif($DictionaryKey -eq 'TypeName')
{
	$dictionary = @{}
	([PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get).GetEnumerator() |
		ForEach-Object {$dictionary[$_.Value.FullName] = $_.Key}
	return $dictionary
}
else
{
	return ([PSObject].Assembly.GetType('System.Management.Automation.TypeAccelerators')::Get).GetEnumerator() |
		ForEach-Object {[pscustomobject]@{
			Alias = $_.Key
			Type  = [type]$_.Value
			Suffix = switch($_.Key)
			{
				byte    {'y'}
				sbyte   {'uy'}
				short   {'s'}
				ushort  {'us'}
				int16   {'s'}
				uint16  {'us'}
				long    {'l'}
				ulong   {'ul'}
				int64   {'l'}
				uint64  {'ul'}
				uint    {'u'}
				uint32  {'u'}
				bigint  {'n'}
				decimal {'d'}
			}
		}}
}
