<#
.SYNOPSIS
Gets the framework version an assembly was compiled for.

.INPUTS
Objects with System.String properties named Path or FullName.

.OUTPUTS
System.Management.Automation.PSCustomObject with RuntimeVersion and CompileVersion properties.

.LINK
https://stackoverflow.com/questions/3460982/determine-net-framework-version-for-dll#25649840

.EXAMPLE
Get-AssemblyFramework.ps1 Program.exe

RuntimeVersion CompileVersion
-------------- --------------
v4.0.30319     .NETFramework,Version=v4.7.2
#>

[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param(
# The assembly to get the framework version of.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)][Alias('FullName')][string] $Path
)

$assembly = [Reflection.Assembly]::ReflectionOnlyLoadFrom((Resolve-Path $Path))
[PSCustomObject]@{
    RuntimeVersion = $assembly.ImageRuntimeVersion
    CompileVersion = $assembly.CustomAttributes |
        ? {$_.AttributeType.Name -eq "TargetFrameworkAttribute" } |
        % {$_.ConstructorArguments.value}
}
