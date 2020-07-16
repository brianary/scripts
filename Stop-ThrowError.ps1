<#
.Synopsis
	Throws a better error than "throw".

.Description
	The PowerShell "throw" keyword doesn't do a good job of providing actionable
	detail or context:

		Unable to remove root node.
		At C:\Scripts\Remove-Xml.ps1:34 char:37
		+ ...  if($node.ParentNode -eq $null) {throw 'Unable to remove root node.'}
		+                                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			+ CategoryInfo          : OperationStopped: (Unable to remove root node.:String) [], RuntimeException
			+ FullyQualifiedErrorId : Unable to remove root node.

	It only shows where the "throw" was used in the called script!

	Using $PSCmdlet.ThrowTerminatingError() does a much better job:

		C:\Scripts\Remove-Xml.ps1 : Unable to remove root node
		Parameter name: SelectXmlInfo
		At C:\Scripts\Test-Error.ps1:2 char:23
		+ '<a/>' |Select-Xml / |Remove-Xml.ps1
		+                       ~~~~~~~~~~~~~~
			+ CategoryInfo          : InvalidArgument: (<a />:SelectXmlInfo) [Remove-Xml.ps1], ArgumentException
			+ FullyQualifiedErrorId : RootRequired,Remove-Xml.ps1

	Now you can see where the trouble is in the calling script!

	However, contructing an exception, then using that to construct an error with the right ID & category &
	target object, then using that to call ThrowTerminatingError() is pretty inconvenient.

	This script combines that process into a few simple parameters.

.Parameter ExceptionType
	The type of a Exception class to instantiate as part of the error.

.Parameter ExceptionArguments
	The constructor parameters for the exception class specified by ExceptionTypeName.

.Parameter ErrorCategory
	The error's category, as an enumeration value.

.Parameter TargetObject
	The object in context when the error happened.

.Parameter ErrorId
	An string unique to the script that identifies the error.
	By default this will use the line number it is called from.

.Link
	https://docs.microsoft.com/dotnet/api/system.management.automation.cmdlet.throwterminatingerror

.Link
	https://docs.microsoft.com/dotnet/api/system.management.automation.errorrecord.-ctor

.Link
	Get-Variable

.Link
	New-Object

.Example
	Stop-ThrowError.ps1 'Unable to remove root node' -Argument SelectXmlInfo

	C:\Scripts\Remove-Xml.ps1 : Unable to remove root node
	Parameter name: SelectXmlInfo
	At C:\Scripts\Test-Error.ps1:2 char:23
	+ '<a/>' |Select-Xml / |Remove-Xml.ps1
	+                       ~~~~~~~~~~~~~~
		+ CategoryInfo          : InvalidArgument: (<a />:SelectXmlInfo) [Remove-Xml.ps1], ArgumentException
		+ FullyQualifiedErrorId : SelectXmlInfo,Remove-Xml.ps1
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
[Parameter(ParameterSetName='CatchBlock',Position=0)]
[Parameter(ParameterSetName='Detailed',Mandatory=$true,Position=0)][Type] $ExceptionType,
[Parameter(ParameterSetName='CatchBlock',Position=1)]
[Parameter(ParameterSetName='Detailed',Mandatory=$true,Position=1)][object[]] $ExceptionArguments,
[Parameter(ParameterSetName='Detailed',Mandatory=$true,Position=2)][Management.Automation.ErrorCategory] $ErrorCategory,
[Parameter(ParameterSetName='Detailed',Mandatory=$true,Position=3)][object] $TargetObject,
[Parameter(ParameterSetName='Detailed',Position=4)][string] $ErrorId =
	"L$(Get-PSCallStack |select -First 1 |% ScriptLineNumber)",
[Parameter(Position=0,ParameterSetName='InvalidArgument',Mandatory=$true)]
[Parameter(Position=0,ParameterSetName='InvalidOperation',Mandatory=$true)]
[Parameter(Position=0,ParameterSetName='ObjectNotFound',Mandatory=$true)]
[Parameter(Position=0,ParameterSetName='NotImplemented',Mandatory=$true)]
[string] $Message,
[Parameter(ParameterSetName='InvalidArgument',Mandatory=$true)][Alias('InvalidArgument')][string] $Argument,
[Parameter(ParameterSetName='InvalidOperation',Mandatory=$true)][Alias('InvalidOperation')] $OperationContext,
[Parameter(ParameterSetName='ItemNotFound',Mandatory=$true)][Alias('ObjectNotFound')] $SearchContext,
[Parameter(ParameterSetName='NotImplemented',Mandatory=$true)][switch] $NotImplemented
)
[object[]] $params = switch($PSCmdlet.ParameterSetName)
{
	CatchBlock {(Get-Variable PSItem -ValueOnly -Scope 1),(New-Object $ExceptionType.FullName $ExceptionArguments)}
	Detailed {(New-Object $ExceptionType.FullName $ExceptionArguments),$ErrorId,$ErrorCategory,$TargetObject}
	InvalidArgument
	{
		[Management.Automation.PSBoundParametersDictionary] $ScriptParams =
			Get-Variable PSBoundParameters -ValueOnly -Scope 1 -ErrorAction SilentlyContinue
		$paramValue = if($ScriptParams -and $ScriptParams.ContainsKey($Argument)) {$ScriptParams[$Argument]}
		(New-Object ArgumentException $Message,$Argument),$Argument,'InvalidArgument',$paramValue
	}
	InvalidOperation
	{
		(New-Object InvalidOperationException $Message),($OperationContext.GetType().Name),
			'InvalidOperation',$OperationContext
	}
	ItemNotFound
	{
		(New-Object Management.Automation.ItemNotFoundException $Message),($SearchContext.GetType().Name),
			'ObjectNotFound',$SearchContext
	}
	NotImplemented
	{
		(New-Object Management.Automation.ItemNotFoundException $Message),($SearchContext.GetType().Name),
			'ObjectNotFound',$SearchContext
	}
}
[Exception] $ex = New-Object $ExceptionType.FullName $ExceptionArguments
[Management.Automation.PSCmdlet] $caller = Get-Variable PSCmdlet -ValueOnly -Scope 1 -ErrorAction SilentlyContinue
if(!$caller) {$caller = $PSCmdlet}
$caller.ThrowTerminatingError((New-Object Management.Automation.ErrorRecord $params))
