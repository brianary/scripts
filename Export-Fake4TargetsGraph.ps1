<#
.Synopsis
    Exports a graph of a Fake4 build script's targets.

.Notes
    TODO: Parameterize Fake version, with a default.
    TODO: Install Fake4 from NuGet, by version, if missing.
    TODO: Use-Command.ps1 Graphviz (if missing).
    TODO: Parameterize build script file.
    TODO: Parameterize build target, and include only it and its dependencies.
    TODO: Parameterize format (maybe as a dynamic param, using `dot -T? 2>&1` for ValidateSet), default to "svg".
    TODO: Parameterize output filename.
    TODO: Parameterize renderer, default to "dot".
    TODO: For "gv" format, skip the rendering step.
    TODO: Invoke-Item?
#>

#Requires -Version 3
[CmdletBinding()] Param()

fake4 -dg 2>&1 |? {$_ -match '^(digraph|  |})'} |Out-String |dot --% -Tsvg -obuild.svg
