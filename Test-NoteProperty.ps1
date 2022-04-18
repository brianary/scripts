<#
.SYNOPSIS
Looks for any matching NoteProperties on an object.

.INPUTS
System.Management.Automation.PSObject, perhaps created via [PSCustomObject]@{ … }
or ConvertFrom-Json or Invoke-RestMethod that may have NoteProperties.

.OUTPUTS
System.Boolean indicating at least one matching NoteProperty was found.

.EXAMPLE
$r = Invoke-RestMethod @args; if(Test-NoteProperty.ps1 -Name Status -InputObject $r) { … }

Executes the "if" block if there is a status NoteProperty present.

.EXAMPLE
Get-Content records.json |ConvertFrom-Json |? {$_ |Test-NoteProperty.ps1 *Addr*} |…

Passes objects through the pipeline that have a property containing "Addr" in the name.
#>
[CmdletBinding()][OutputType([bool])] Param(
# The name of the property to look for. Wildcards are supported.
[Parameter(Mandatory=$true,Position=0)][string] $Name,
# The object to examine.
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][psobject]$InputObject
)
Process {[bool](Get-Member -InputObject $InputObject -Name $Name -MemberType NoteProperty -ErrorAction SilentlyContinue)}
