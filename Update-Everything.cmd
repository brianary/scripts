taskkill /im powershell.exe /f
taskkill /im pwsh.exe /f
taskkill /im WindowsTerminal.exe /f
cup powershell powershell-core microsoft-windows-terminal -y
pwsh -nol -nop -noni -file %~dpn0.ps1
