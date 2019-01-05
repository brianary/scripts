<#
.Synopsis
    Gets current console color details.

.Example
    Get-ConsoleColors.ps1

    Value Name        RgbHex  Color
    ----- ----        ------  -----
        0 Black       #000000 Color [A=0, R=0, G=0, B=0]
        1 DarkBlue    #000080 Color [A=0, R=128, G=0, B=0]
        2 DarkGreen   #008000 Color [A=0, R=0, G=128, B=0]
        3 DarkCyan    #008080 Color [A=0, R=128, G=128, B=0]
        4 DarkRed     #800000 Color [A=0, R=0, G=0, B=128]
        5 DarkMagenta #012456 Color [A=0, R=86, G=36, B=1]
        6 DarkYellow  #EEEDF0 Color [A=0, R=240, G=237, B=238]
        7 Gray        #C0C0C0 Color [A=0, R=192, G=192, B=192]
        8 DarkGray    #808080 Color [A=0, R=128, G=128, B=128]
        9 Blue        #0000FF Color [A=0, R=255, G=0, B=0]
       10 Green       #00FF00 Color [A=0, R=0, G=255, B=0]
       11 Cyan        #00FFFF Color [A=0, R=255, G=255, B=0]
       12 Red         #FF0000 Color [A=0, R=0, G=0, B=255]
       13 Magenta     #FF00FF Color [A=0, R=255, G=0, B=255]
       14 Yellow      #FFFF00 Color [A=0, R=0, G=255, B=255]
       15 White       #FFFFFF Color [Transparent]
#>

#Require -Verbose 3
[CmdletBinding()] Param()
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

[uint32[]]$colors = [ConsoleColors]::GetAgbrColors()
foreach($color in [Enum]::GetValues([ConsoleColor]))
{
    [pscustomobject]@{
        Value  = [int]$color
        Name   = [string]$color
        RgbHex = '#{0:X2}{1:X2}{2:X2}' -f @([BitConverter]::GetBytes($colors[$color]))
        Color  = [Drawing.Color]$colors[$color]
    }
}
