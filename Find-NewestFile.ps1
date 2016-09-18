<#
.Synopsis
    Finds the most recent file.

.Parameter Files
    The list of files to search.

.Inputs
    System.IO.FileSystemInfo

.Outputs
    System.IO.FileSystemInfo

.Link
    Test-NewerFile.ps1
#>

#requires -version 3
[CmdletBinding()] Param(
[Parameter(ParameterSetName='Pipeline',ValueFromPipeline=$true,ValueFromRemainingArguments=$true)]
[IO.FileInfo[]]$Files
)
Begin   { $NewestFile = $null }
Process { $Files |% {if(Test-NewerFile.ps1 $NewestFile $_){$NewestFile=$_;Write-Verbose "Newest: $($_.FullName)"}} }
End     { $NewestFile }
