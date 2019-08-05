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
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)][AllowEmptyString()][AllowNull()][string]$Name,
[Parameter(Position=1)][ValidatePattern('\A(?:Global|Script|Local|\d+)\z')][string]$Scope = 'All'
)
Process
{
    if($Name -in $null,'')
    {
        return $false
    }
    elseif($Scope -eq 'All')
    {
        $allscopes = 'Script','Global'
        $scopedepth = (Get-PSCallStack).Count -1
        if($scopedepth -gt 1) {$allscopes += 1..$scopedepth}
        foreach($s in $allscopes)
        {
            if(Get-Variable -Name $Name -Scope $s -ErrorAction SilentlyContinue) {return $true}
            Write-Debug "$($MyInvocation.MyCommand.Name): $Name not found in scope $s"
        }
        return $false
    }
    else
    {
        if($Scope -eq 'Local') {$Scope = 1}
        elseif($Scope -match '\d+') {$Scope = 1+$Scope}
        return [bool](Get-Variable -Name $Name -Scope $Scope -ErrorAction SilentlyContinue)
    }
}
