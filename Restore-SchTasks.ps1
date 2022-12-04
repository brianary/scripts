<#
.SYNOPSIS
Imports from a single XML file into the local Scheduled Tasks.

.FUNCTIONALITY
Scheduled Tasks

.LINK
https://msdn.microsoft.com/library/windows/desktop/bb736357.aspx

.LINK
Select-Xml

.LINK
Get-Credential

.EXAMPLE
Restore-SchTasks.ps1

(Imports scheduled tasks from tasks.xml, prompting for passwords as needed.)
#>

#Requires -Version 3
[CmdletBinding()][OutputType([void])] Param(
# The file to import tasks from, as exported from Backup-SchTasks.ps1.
[Parameter(Position=0)][string] $Path = 'tasks.xml',
<#
A wildcard pattern to match task "paths" (including folders) to skip.

User tasks are usually just in the root, and generally machine-specific
tasks Microsoft automatically sets up are in folders so this is *\* by
default to exclude the weird magic tasks.
#>
[string] $Exclude = '*\*'
)
$credentials = @{}
$xmldecl = "<?xml version=`"1.0`" encoding=`"UTF-16`" ?>{0}{0}" -f [environment]::NewLine
$Script:PSDefaultParameterValues = @{'Select-Xml:Namespace'=@{task='http://schemas.microsoft.com/windows/2004/02/mit/task'}}
foreach($task in ((Get-Content $Path -Raw) -replace '(?<=\A|>)\s*</?Tasks>\s*(?=\S|\z)','') -split '(?<=</Task>)\s*?(?=<!--)')
{
    $xml = [xml]$task
    $name = (Select-Xml '/comment()' -Xml $xml).Node.Value.Trim().TrimStart('\')
    if($Exclude -and ($name -like $Exclude)) { Write-Verbose "Skipping task $name"; continue }
    else { Write-Verbose "Importing task $name" }
    Out-File "$name.xml" -Encoding unicode -InputObject "$xmldecl$task"  -Width ([int]::MaxValue)
    $logon = (Select-Xml '/task:Task/task:Principals/task:Principal[@id=''Author'']/task:LogonType' -Xml $xml).Node.InnerText
    if($logon -ne 'Password')
    {
        Write-Verbose "Importing logon type $logon"
        schtasks /Create /TN $name /XML "$name.xml"
    }
    else
    {
        $user = (Select-Xml '/task:Task/task:Principals/task:Principal[@id=''Author'']/task:UserId' -Xml $xml).Node.InnerText
        if(!$credentials.ContainsKey($user))
        {
            $cred = Get-Credential $user -Message "Please enter credentials to run '$name' job as"
            if(!$credentials.ContainsKey($cred.UserName)) { $credentials[$cred.UserName] = $cred }
        }
        if($user -ne $cred.UserName) { Write-Verbose "Importing to run as $($cred.UserName)" }
        schtasks /Create /RU $cred.UserName /RP $cred.GetNetworkCredential().Password /TN $name /XML "$name.xml"
    }
    rm "$name.xml"
}
