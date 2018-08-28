<#
.Synopsis
    Gets the framework version an assembly was compiled for.

.Parameter Path
    The assembly to get the framework version of.

.Link
    https://stackoverflow.com/questions/3460982/determine-net-framework-version-for-dll#25649840

.Example
    Get-AssemblyFramework.ps1 Program.exe

    RuntimeVersion CompileVersion
    -------------- --------------
    v4.0.30319     .NETFramework,Version=v4.7.2
#>

[CmdletBinding()] Param(
[Parameter(Position=0,Mandatory=$true)][string]$Path
)

$assembly = [Reflection.Assembly]::ReflectionOnlyLoadFrom((Resolve-Path $Path))
[PSCustomObject]@{
    RuntimeVersion = $assembly.ImageRuntimeVersion
    CompileVersion = $assembly.CustomAttributes |
        ? {$_.AttributeType.Name -eq "TargetFrameworkAttribute" } |
        % {$_.ConstructorArguments.value}
}
