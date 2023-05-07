<#
.SYNOPSIS
Gets current console color details.

.OUTPUTS
System.Management.Automation.PSCustomObject of each console color setting.

.COMPONENT
System.Drawing

.EXAMPLE
Get-ConsoleColors.ps1 |Format-Table -AutoSize

Value Name        RgbHex  Color                            PowerShellUsage
----- ----        ------  -----                            ---------------
0 Black       #000000 Color [A=0, R=0, G=0, B=0]       {ErrorBackgroundColor, WarningBackgroundColor, DebugBackgroundColor, VerboseBackgroundColor}
1 DarkBlue    #800000 Color [A=0, R=128, G=0, B=0]     {}
2 DarkGreen   #008000 Color [A=0, R=0, G=128, B=0]     {}
3 DarkCyan    #808000 Color [A=0, R=128, G=128, B=0]   {StringForegroundColor, ProgressBackgroundColor}
4 DarkRed     #000080 Color [A=0, R=0, G=0, B=128]     {}
5 DarkMagenta #562401 Color [A=0, R=86, G=36, B=1]     {BackgroundColor}
6 DarkYellow  #F0EDEE Color [A=0, R=240, G=237, B=238] {ForegroundColor}
7 Gray        #C0C0C0 Color [A=0, R=192, G=192, B=192] {}
8 DarkGray    #808080 Color [A=0, R=128, G=128, B=128] {OperatorForegroundColor}
9 Blue        #FF0000 Color [A=0, R=255, G=0, B=0]     {}
10 Green       #00FF00 Color [A=0, R=0, G=255, B=0]     {VariableForegroundColor}
11 Cyan        #FFFF00 Color [A=0, R=255, G=255, B=0]   {}
12 Red         #0000FF Color [A=0, R=0, G=0, B=255]     {ErrorForegroundColor}
13 Magenta     #FF00FF Color [A=0, R=255, G=0, B=255]   {}
14 Yellow      #00FFFF Color [A=0, R=0, G=255, B=255]   {CommandForegroundColor, WarningForegroundColor, DebugForegroundColor, VerboseForegroundColor...}
15 White       #FFFFFF Color [Transparent]              {NumberForegroundColor, NumberForegroundColor}
#>

#Require -Verbose 3
[CmdletBinding()][OutputType([Management.Automation.PSCustomObject])] Param()
try{[void][Drawing.Color]}catch{Add-Type -AN System.Drawing}
try{[void][ConsoleColors]}catch{Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public class ConsoleColors
{
    [StructLayout(LayoutKind.Sequential)]
    internal struct ScreenBufferInfoEx
    {
        internal int StructSize;
        internal short Width;
        internal short Height;
        internal short CursorX;
        internal short CursorY;
        internal ushort wAttributes;
        internal short WindowLeft;
        internal short WindowTop;
        internal short WindowRight;
        internal short WindowBottom;
        internal short MaxWidth;
        internal short MaxHeight;
        internal ushort wPopupAttributes;
        internal bool bFullscreenSupported;
        [MarshalAs(UnmanagedType.ByValArray, SizeConst=16)] internal uint[] ColorTable;
    }

    const int OutputHandle = -11;                                   // per WinBase.h
    internal static readonly IntPtr InvalidHandle = new IntPtr(-1); // per WinBase.h

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern IntPtr GetStdHandle(int nStdHandle);

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern bool GetConsoleScreenBufferInfoEx(IntPtr hConsoleOutput, ref ScreenBufferInfoEx info);

    public static uint[] GetAgbrColors()
    {
        ScreenBufferInfoEx info = new ScreenBufferInfoEx();
        info.StructSize = (int)Marshal.SizeOf(info);         // 96 = 0x60
        IntPtr hConsoleOutput = GetStdHandle(OutputHandle);  // 7
        if (hConsoleOutput == InvalidHandle)
        {throw new ApplicationException("Bad handle");}
        if (!GetConsoleScreenBufferInfoEx(hConsoleOutput, ref info))
        {throw new ApplicationException("Buffer info call failed");}
        return info.ColorTable;
    }
}
'@}

$usage = @{}
foreach($color in [Enum]::GetValues([ConsoleColor]))
{$usage[$color] = @()}
$usage[[ConsoleColor]'DarkCyan'] += 'StringForegroundColor'
$usage[[ConsoleColor]'DarkGray'] += 'OperatorForegroundColor'
$usage[[ConsoleColor]'Green']    += 'VariableForegroundColor'
$usage[[ConsoleColor]'Yellow']   += 'CommandForegroundColor'
$usage[[ConsoleColor]'White']    += 'NumberForegroundColor'
$usage[$Host.UI.RawUI.ForegroundColor] += 'ForegroundColor'
$usage[$Host.UI.RawUI.BackgroundColor] += 'BackgroundColor'
foreach($context in 'Error','Warning','Debug','Verbose','Progress')
{
    $usage[$Host.PrivateData."${context}ForegroundColor"] += "${context}ForegroundColor"
    $usage[$Host.PrivateData."${context}BackgroundColor"] += "${context}BackgroundColor"
}
[uint32[]]$agbrs = [ConsoleColors]::GetAgbrColors()
foreach($color in [Enum]::GetValues([ConsoleColor]))
{
    $byte = [BitConverter]::GetBytes($agbrs[$color])
    $byte[0],$byte[2] = $byte[2],$byte[0]
    $value = [Drawing.Color][BitConverter]::ToInt32($byte,0)
    [pscustomobject]@{
        Value  = [int]$color
        Name   = [string]$color
        RgbHex = '#{0:X2}{1:X2}{2:X2}' -f $value.R,$value.G,$value.B
        Color  = $value
        PowerShellUsage = $usage[$color]
    }
}

