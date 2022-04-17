<#
.SYNOPSIS
Exports a graph of a Fake4 build script's targets.

.PARAMETER Renderer
The name of the Graphviz rendering engine to use.

.PARAMETER Format
The output format of the graph.

.PARAMETER OutFile
The filename to output the graph to.

.PARAMETER FakeVersion
The specific version of Fake4 to install if it is missing.

.NOTES
TODO: Parameterize build script file.
TODO: Parameterize build target, and include only it and its dependencies.
TODO: Invoke-Item?

.EXAMPLE
Export-Fake4TargetsGraph.ps1

Parses build.fsx and shows the target dependency graph in build.svg.
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
[ValidateSet('dot','circo','sfdp','twopi')][string] $Renderer = 'dot',
[ValidateSet('bmp','gif','gv','jpg','pdf','png','ps','svg','svgz','tiff','vml','vmlz')]
[string] $Format = 'svg',
[string] $OutFile = "build.$Format",
[ValidatePattern('\A4\.\S+\z')][string] $FakeVersion = '4.64.17'
)
Begin
{
    Use-Command.ps1 fake4 "$env:LOCALAPPDATA\Fake\tools\fake.exe" -nupkg fake -Version $FakeVersion -InstallDir $env:LOCALAPPDATA
    Use-Command.ps1 dot "$env:ChocolateyInstall\bin\dot.exe" -cinst graphviz
}
Process
{
    if($Format -eq 'gv') {fake4 -dg 2>&1 |? {$_ -match '^(digraph|  |})'} |Out-File $OutFile ascii}
    else {fake4 -dg 2>&1 |? {$_ -match '^(digraph|  |})'} |Out-String |& $Renderer "-T$Format" "-o$OutFile"}
}
