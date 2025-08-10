<#
.SYNOPSIS
Generates a Mermaid XY bar/line chart for the values of a series of properties.

.FUNCTIONALITY
Mermaid Diagrams

.INPUTS
System.Object with the properties requested.

.OUTPUTS
System.String containing Mermaid XY chart data.

.LINK
https://mermaid.js.org/syntax/xyChart.html

.EXAMPLE
Get-Item Save-*.ps1 |Export-MermaidXY.ps1 -Title "Save scripts" -Units bytes -LabelProperty Name -BarProperty Length

xychart-beta
title "Save scripts"
x-axis "" [Save-PodcastEpisodes.ps1, Save-Secret.ps1, Save-WebRequest.ps1]
y-axis "bytes" 0 --> 3239
bar "Length" [2754, 3239, 3112]
#>

#Requires -Version 7
[CmdletBinding()] Param(
# The property to use as labels on the X axis.
[string] $LabelProperty,
# Properties to use to render a line graph.
[string[]] $LineProperty = @(),
# Properties to use to render a bar graph.
[string[]] $BarProperty = @(),
# A title for the chart.
[string] $Title,
# The label for the X axis.
[Alias('Domain','Progression')][string] $XAxisLabel,
# The label for the Y axis.
[Alias('Range','Units')][string] $YAxisLabel,
# The objects with the specified properties.
[Parameter(ValueFromPipeline=$true)][psobject] $InputObject
)
Begin
{
    filter Format-Values
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0,Mandatory=$true)][psobject[]] $ChartData,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)][string] $Property,
        [ValidateSet('bar','line')][string] $Type
        )
        $Local:OFS = ', '
        return "$Type `"$Property`" [$($ChartData |Select-Object -ExpandProperty $Property)]"
    }
}
End
{
    $data = $input
    $labels = $data |Select-Object -ExpandProperty $LabelProperty
    $minmax = $LineProperty + $BarProperty |ForEach-Object {$data |Select-Object -ExpandProperty $_} |Measure-Object -Minimum -Maximum 
    $min = $minmax.Minimum -gt 0 ? 0 : $minmax.Minimum
    $max = $minmax.Maximum
    $Local:OFS = "`n"
    return @"
xychart-beta
title "$Title"
x-axis "$XAxisLabel" [$($labels -join ', ')]
y-axis "$YAxisLabel" $min --> $max
$(@($LineProperty |Format-Values -ChartData $data -Type line) + @($BarProperty |Format-Values -ChartData $data -Type bar))
"@
}
