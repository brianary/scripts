<#
.SYNOPSIS
Switch the Java version for the current process by modifying environment variables.

.INPUTS
System.String path to use as the new JAVA_HOME environment variable.

.FUNCTIONALITY
System and updates

.EXAMPLE
Use-Java.ps1 "$env:ProgramFiles\OpenJDK\jdk-11.0.1"
#>

[CmdletBinding()][OutputType([void])] Param(
# The path to the JRE/JDK to use, which must contain bin\java.exe.
[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
[ValidateScript({(Test-Path $_ -PathType Container) -and (Test-Path "$_\bin\java.exe" -PathType Leaf)})]
[Alias('FullName')][string] $Path
)

$env:JAVA_HOME = $Path
Write-Verbose "JAVA_HOME=$env:JAVA_HOME"
if($env:JDK_HOME)
{
    $env:JDK_HOME = $env:JAVA_HOME
    Write-Verbose "JDK_HOME=$env:JDK_HOME"
}
if($env:JRE_HOME -and (Test-Path "$env:JAVA_HOME\jre" -PathType Container))
{
    $env:JRE_HOME = "$env:JAVA_HOME\jre"
    Write-Verbose "JRE_HOME=$env:JRE_HOME"
}
if($env:CLASSPATH)
{
    $env:CLASSPATH = ".;$env:JAVA_HOME\lib;$env:JAVA_HOME\jre\lib"
    Write-Verbose "CLASSPATH=$env:CLASSPATH"
}
$env:Path = ($env:Path -split ';' |ForEach-Object {if($_ -match 'Java|JDK'){"$Path\bin"}else{$_}}) -join ';'
Write-Verbose "Path=$($env:Path -replace ';',([Environment]::NewLine))"
${java.exe} = (Get-Command java.exe -CommandType Application).Path
Write-Verbose "Using Java ${java.exe} ($((Get-Item ${java.exe}).VersionInfo.ProductVersion))"
