<#
.Synopsis
    Looks for any matching NoteProperties on an object.

.Parameter Name
    The name of the property to look for. Wildcards are supported.

.Parameter InputObject
    The object to examine.

.Inputs
    System.Management.Automation.PSObject, perhaps created via [PSCustomObject]@{ … }
    or ConvertFrom-Json or Invoke-RestMethod that may have NoteProperties.

.Outputs
    System.Boolean indicating at least one matching NoteProperty was found.

.Example
    $r = Invoke-RestMethod @args; if(Test-NoteProperty.ps1 -Name Status -InputObject $r) { … }

    Executes the "if" block if there is a status NoteProperty present.

.Example
    Get-Content records.json |ConvertFrom-Json |? {$_ |Test-NoteProperty.ps1 *Addr*} |…

    Passes objects through the pipeline that have a property containing "Addr" in the name.
#>
[CmdletBinding()][OutputType([bool])] Param(
[Parameter(Mandatory=$true,Position=0)][string] $Name,
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][psobject]$InputObject
)
Process {[bool](Get-Member -InputObject $InputObject -Name $Name -MemberType NoteProperty -ErrorAction SilentlyContinue)}
