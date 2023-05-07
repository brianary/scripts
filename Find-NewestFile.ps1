<#
.SYNOPSIS
Finds the most recent file.

.INPUTS
System.IO.FileInfo[] a list of files to compare.

.OUTPUTS
System.IO.FileInfo representing the newest of the files compared.

.FUNCTIONALITY
Files

.LINK
Test-NewerFile.ps1

.EXAMPLE
ls C:\java.exe -Recurse -ErrorAction Ignore |Find-NewestFile.ps1

Directory: C:\Program Files (x86)\Minecraft\runtime\jre-x64\1.8.0_25\bin

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----       2017-02-05     15:03         190888 java.exe
#>

#Requires -Version 3
[CmdletBinding()][OutputType([IO.FileInfo])] Param(
# The list of files to search.
[Parameter(ValueFromPipeline=$true,ValueFromRemainingArguments=$true)]
[IO.FileInfo[]]$Files
)
Begin   { $NewestFile = $null }
Process { $Files |ForEach-Object {if(Test-NewerFile.ps1 $NewestFile $_){$NewestFile=$_}} }
End     { $NewestFile }

