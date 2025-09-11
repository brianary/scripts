<#
.SYNOPSIS
Caches the output of a command for recall if called again.

.FUNCTIONALITY
Command

.EXAMPLE
Invoke-CachedCommand.ps1 {Invoke-RestMethod https://example.org/endpoint} -Session

Returns the result of executing the script block, or the previous cached output if available.
#>

#Requires -Version 7
[CmdletBinding()] Param(
# Specifies the expression to cache the output of.
[Parameter(Position=0,Mandatory=$true)][scriptblock] $Expression,
# Parameters to the script block.
[Parameter(Position=1,ValueFromRemainingArguments=$true)][psobject[]] $BlockArgs = @(),
# The rolling duration to cache the output for (updated with each call).
[Parameter(ParameterSetName='ExpiresAfter')][timespan] $ExpiresAfter,
# Point in time to cache the output until.
[Parameter(ParameterSetName='Expires')][datetime] $Expires,
# Caches the output for this session.
[Parameter(ParameterSetName='Session')][switch] $Session,
# Forces rerunning the command to update the cache.
[switch] $Force
)
Begin
{
    function Initialize-Variables
    {
        [CmdletBinding()] Param()
        $Script:Hash = [Security.Cryptography.MD5]::Create()
        $Script:SessionCacheName = "$(Split-Path $PSCommandPath -LeafBase)#$PID"
        $Script:SessionCache = Get-Variable $Script:SessionCacheName -Scope Global -ErrorAction Ignore
        if(!$Script:SessionCache)
        {
            $Script:SessionCache = Set-Variable $Script:SessionCacheName @{} -Scope Global -Option Constant -PassThru `
                -Description 'Cached command output'
        }
        $Script:CacheDir = if($IsWindows)
        {
            Join-Path $env:LocalAppData (Split-Path $PSCommandPath -LeafBase)
        }
        elseif($IsLinux)
        {
            Join-Path ($env:XDG_CACHE_HOME ?? "$HOME/.cache") (Split-Path $PSCommandPath -LeafBase)
        }
        else
        {
            Join-Path $env:TEMP (Split-Path $PSCommandPath -LeafBase)
        }
        New-Item $Script:CacheDir -Type Directory -ErrorAction Ignore |Out-Null
        Get-ChildItem $Script:CacheDir |
            Where-Object LastWriteTime -lt (Get-Date) |
            Remove-Item
    }

    function Get-ScriptBlockHash
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0)][scriptblock] $ScriptBlock,
        [Parameter(Position=1)][psobject[]] $BlockArgs = @()
        )
        return (@("$ScriptBlock") + @($BlockArgs |ForEach-Object {ConvertTo-Json $_ -Compress}) |
            ForEach-Object {ConvertTo-Base64.ps1 $Script:Hash.ComputeHash([Text.Encoding]::UTF8.GetBytes($_)) -UriStyle}) -join '.'
    }

    function Get-CachedOutput
    {
        [CmdletBinding()] Param(
        [Parameter(Position=0)][scriptblock] $ScriptBlock,
        [Parameter(Position=1)][psobject[]] $BlockArgs = @(),
        [datetime] $Expires,
        [switch] $Force
        )
        $now = Get-Date
        $cacheFileName = Join-Path $Script:CacheDir "$(Get-ScriptBlockHash $ScriptBlock -BlockArgs $BlockArgs).xml"
        if(Test-Path $cacheFileName -Type Leaf)
        {
            $cacheFile = Get-Item $cacheFileName
            if($now -gt $cacheFile.LastWriteTime -or $Force)
            {
                $ScriptBlock.InvokeReturnAsIs(@($BlockArgs)) |Export-Clixml $cacheFileName -Force
            }
        }
        else
        {
            $ScriptBlock.InvokeReturnAsIs(@($BlockArgs)) |Export-Clixml $cacheFileName
            $cacheFile = Get-Item $cacheFileName
        }
        $cacheFile.LastWriteTime = $Expires
        Import-Clixml $cacheFileName
    }
}
Process
{
    Initialize-Variables
    switch($PSCmdlet.ParameterSetName)
    {
        ExpiresAfter {Get-CachedOutput $Expression -BlockArgs $BlockArgs -Expires (Get-Date).Add($ExpiresAfter) -Force:$Force}
        Expires {Get-CachedOutput $Expression -BlockArgs $BlockArgs -Expires $Expires -Force:$Force}
        Session
        {
            $key = Get-ScriptBlockHash $Expression -BlockArgs $BlockArgs
            if($Force -or !$Script:SessionCache.Value.ContainsKey($key))
            {
                $Script:SessionCache.Value[$key] = $Expression.InvokeReturnAsIs(@($BlockArgs))
            }
            return $Script:SessionCache.Value[$key]
        }
    }
}
