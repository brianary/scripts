<#
.Synopsis
	Create a new JSON string by recursively combining the properties of JSON strings.

.Parameter InputObject
    JSON string to combine. Descendant properties are recursively merged.
    Primitive values are overwritten by any matching ones in the new JSON string.

.Parameter Compress
    Omits white space and indented formatting in the output string.

.Inputs
    System.String of JSON to combine.

.Outputs
    System.String of JSON combining the inputs.

.Link
    Merge-PSObject.ps1

.Link
    ConvertFrom-Json

.Link
    ConvertTo-Json

.Example
    '{"a":1,"b":{"u":3},"c":{"v":5}}','{"a":{"w":8},"b":2,"c":{"x":6}}' |Merge-Json.ps1

    {
        "a":  {
                "w":  8
            },
        "b":  2,
        "c":  {
                "v":  5,
                "x":  6
            }
    }
#>

#Requires -Version 3
[CmdletBinding()][OutputType([string])] Param(
[Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromRemainingArguments=$true)][string[]] $InputObject,
[switch]$Compress
)
Begin {$value = [pscustomobject]@{}}
Process {$value = $value,($InputObject |ConvertFrom-Json) |Merge-PSObject.ps1}
End {$value  |ConvertTo-Json -Compress:$Compress}
