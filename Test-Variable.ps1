<#
.Synopsis
    Indicates whether a variable has been defined.

.Parameter Name
    A variable name to test the existence of.

.Inputs
    System.String name of a variable.

.Outputs
    System.Boolean indicating whether the variable name is defined.

.Link
    Get-Variable

.Example
    Test-Variable.ps1 true

    True

.Example
    Test-Variable.ps1 ''

    False

    A variable can't have an empty string for a name.

.Example
    Test-Variable.ps1 $null

    False

    A variable can't have a null name.

.Example
    Test-Variable.ps1 null

    True

.Example
    'PSVersionTable','false' |Test-Variable.ps1

    True
    True

.Example
    'PWD','PID' |Test-Variable.ps1 -Scope Global

    True
    True
#>

#Requires -Version 3
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][AllowEmptyString()][AllowNull()][string] $Name,
[Parameter(Position=1)][string] $Scope
)
Process
{
    if($Name -in $null,'')
    {
        return $false
    }
    elseif(!$Scope)
    {
		if(Get-Variable -Name $Name -ErrorAction SilentlyContinue) {return $true}
		$Error.RemoveAt(0)
		Write-Debug "$($MyInvocation.MyCommand.Name): $Name not found in default scope"
        return $false
    }
    else
    {
		$Scope = Add-ScopeLevel.ps1 $Scope
		if(Get-Variable -Name $Name -Scope $Scope -ErrorAction SilentlyContinue) {return $true}
		$Error.RemoveAt(0)
		Write-Debug "$($MyInvocation.MyCommand.Name): $Name not found in $Scope scope"
		return $false
    }
}
