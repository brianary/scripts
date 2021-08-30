<#
.Synopsis
    Finds the most recent file.

.Parameter Files
    The list of files to search.

.Inputs
    System.IO.FileInfo[] a list of files to compare.

.Outputs
    System.IO.FileInfo representing the newest of the files compared.

.Link
    Test-NewerFile.ps1

.Example
    ls C:\java.exe -Recurse -ErrorAction SilentlyContinue |Find-NewestFile.ps1

        Directory: C:\Program Files (x86)\Minecraft\runtime\jre-x64\1.8.0_25\bin

    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    -a----       2017-02-05     15:03         190888 java.exe
#>

#Requires -Version 3
[CmdletBinding()][OutputType([IO.FileInfo])] Param(
[Parameter(ValueFromPipeline=$true,ValueFromRemainingArguments=$true)]
[IO.FileInfo[]]$Files
)
Begin   { $NewestFile = $null }
Process { $Files |% {if(Test-NewerFile.ps1 $NewestFile $_){$NewestFile=$_}} }
End     { $NewestFile }
