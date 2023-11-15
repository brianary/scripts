<#
.SYNOPSIS
Test a given connection string and provide details about the connection.

.OUTPUTS
System.Management.Automation.PSObject containing properties about the connection.

.FUNCTIONALITY
Database

.EXAMPLE
Test-ConnectionString.ps1 'Server=(localdb)\ProjectsV13;Integrated Security=SSPI;Encrypt=True' -Details

ServerName           : SERVERNAME\LOCALDB#DCCC9EEC
AppName              : Core Microsoft SqlClient Data Provider
LocalRunAsAdmin      : False
ConnectingAsUser     : SERVERNAME\username
SqlInstance          : (localdb)\ProjectsV13
LocalWindows         : 10.0.19045.0
InstanceName         : LOCALDB#DCCC9EEC
DatabaseName         : master
AuthType             : Windows Authentication
Integrated Security  : True
Data Source          : (localdb)\ProjectsV13
ConnectSuccess       : True
Workstation ID       : SERVERNAME
AuthScheme           : NTLM
ComputerName         : SERVERNAME
Encrypt              : True
LocalCLR             : 
TcpPort              : 1433
LocalPowerShell      : 7.3.9
NetBiosName          : SERVERNAME
Edition              : Express Edition (64-bit)
IPAddress            : 192.168.1.223
ServerTime           : 2023-11-10 12:14:09
DomainName           : WORKGROUP
Server               : [(localdb)\ProjectsV13]
IsPingable           : True
LocalEdition         : Core
Pooling              : True
LocalDomainUser      : False
MachineName          : SERVERNAME
SqlVersion           : 13.0.4001
LocalSMOVersion      : 17.100.0.0
#>

#Requires -Version 3
#Requires -Modules dbatools
[CmdletBinding()][OutputType([psobject])] Param(
[Parameter(Position=0,Mandatory=$true)][string] $ConnectionString,
[switch] $Details
)
Process
{
    try
    {
        if($Details)
        {
            $csb = New-DbaConnectionStringBuilder -ConnectionString $ConnectionString
            $server = Connect-DbaInstance -ConnectionString $ConnectionString
            $conn = Join-Keys.ps1 -ReferenceObject (New-Object Collections.Hashtable $csb) `
                -InputObject (Test-DbaConnection $csb.DataSource -SkipPSRemoting |ConvertTo-OrderedDictionary.ps1)
            $info = Invoke-DbaQuery -SqlInstance $server -As PSObject -Query @'
select @@ServerName [ServerName], db_name() [DatabaseName],
       serverproperty('ComputerNamePhysicalNetBIOS') [ComputerName],
       serverproperty('MachineName') [MachineName],
       serverproperty('InstanceName') [InstanceName],
       current_timestamp [ServerTime],
       serverproperty('Edition') [Edition],
       app_name() [AppName];
'@ |ConvertTo-OrderedDictionary.ps1
            if($info.ContainsKey('Password')) {$info['Password'] = ConvertTo-SecureString $info['Password'] -AsPlainText -Force}
            [void] $info.Add('Server', $server)
            return [pscustomobject](Join-Keys.ps1 $conn $info)
        }
        else
        {
            return Invoke-DbaQuery -SqlInstance (Connect-DbaInstance -ConnectionString $ConnectionString) `
                -Query 'select cast(1 as bit) Success;' |ConvertFrom-DataRow.ps1 -AsValues
        }
    }
    catch {return $false}
}
