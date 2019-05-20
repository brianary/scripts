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
    However, contructing an exception, then using that to construct an error, then

.Parameter ExceptionTypeName
    The name of a Exception class to instantiate as part of the error.

.Parameter ExceptionArgumentList
    The constructor parameters for the exception class specified by ExceptionTypeName.

.Parameter ErrorId
    An string unique to the script that identifies the error.

.Parameter ErrorCategory
    The error's category, as an enumeration value.

.Parameter TargetObject
    The object in context when the error happened.

.Link
    https://docs.microsoft.com/dotnet/api/system.management.automation.cmdlet.throwterminatingerror

.Link
    Get-Variable

.Link
    New-Object

.Example
    Stop-ThrowError.ps1 ArgumentException 'Unable to remove root node','SelectXmlInfo' 'RootRequired' InvalidArgument $SelectXmlInfo

    C:\Scripts\Remove-Xml.ps1 : Unable to remove root node
    Parameter name: SelectXmlInfo
    At C:\Scripts\Test-Error.ps1:2 char:23
    + '<a/>' |Select-Xml / |Remove-Xml.ps1
    +                       ~~~~~~~~~~~~~~
        + CategoryInfo          : InvalidArgument: (<a />:SelectXmlInfo) [Remove-Xml.ps1], ArgumentException
        + FullyQualifiedErrorId : RootRequired,Remove-Xml.ps1
#>

#Requires -Version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='CatchBlock',Position=0)]
[Parameter(ParameterSetName='Detailed',Mandatory=$true,Position=0)][string] $ExceptionTypeName,
[Parameter(ParameterSetName='CatchBlock',Position=1)]
[Parameter(ParameterSetName='Detailed',Mandatory=$true,Position=1)][object[]] $ExceptionArgumentList,
[Parameter(ParameterSetName='Detailed',Mandatory=$true,Position=2)][string] $ErrorId,
[Parameter(ParameterSetName='Detailed',Mandatory=$true,Position=3)][Management.Automation.ErrorCategory] $ErrorCategory,
[Parameter(ParameterSetName='Detailed',Mandatory=$true,Position=4)][object] $TargetObject
)
[Exception] $ex = New-Object $ExceptionTypeName $ExceptionArgumentList
[object[]] $params =
    if($PSCmdlet.ParameterSetName -eq 'Detailed') {$ex,$ErrorId,$ErrorCategory,$TargetObject}
    else {(Get-Variable PSItem -ValueOnly -Scope 1),$ex}
[Management.Automation.PSCmdlet]$caller = Get-Variable PSCmdlet -ValueOnly -Scope 1 -ErrorAction SilentlyContinue
if(!$caller) {$caller = $PSCmdlet}
$caller.ThrowTerminatingError((New-Object Management.Automation.ErrorRecord $params))
