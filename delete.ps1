# Clear-Host
# # Self-elevate the script if required
# if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
#       if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
#             $CommandLine = "-NoExit -c cd '$pwd'; & `"" + $MyInvocation.MyCommand.Path + "`""
#             Start-Process powershell -Verb runas -ArgumentList $CommandLine
#             Exit
#       }
# }

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            $CommandLine = $MyInvocation.MyCommand.Path
            Start-Process powershell -Verb runas -ArgumentList $CommandLine
            Exit
      }
}


# Remainder of script here
$FolderPath = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$ShortcutFile = "$FolderPath\intelaudio.lnk"
$TargetPath = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\intelaudio"
$TargetFile = "$TargetPath\intelaudio.exe"
$ProjectPath = "$env:USERPROFILE\hack\mailtrap-keylogger"
$BuildPath = "$ProjectPath\build\intelaudio"
$DepPath = "$BuildPath\localpycs"
$DepFile = "$DepPath\*.pyc"
$DistPath = "$ProjectPath\dist"
$DistFile = "$DistPath\intelaudio.exe"
$DistZip = "$DistPath\intelaudio.zip"

If(Test-Path $ShortcutFile) {
      Remove-Item -Force $ShortcutFile -ErrorAction SilentlyContinue
      Write-Output "Shortcut removed"
      Remove-MpPreference -ExWclusionPath $FolderPath
      Write-Output "Exclusion removed"
}

if (test-path $TargetFile) {
      Remove-item -Force -Path $TargetFile -ErrorAction SilentlyContinue
      Write-Output "Target file removed"
      Remove-MpPreference -ExclusionPath $TargetPath
      Write-Output "Exclusion removed"
      Remove-Item -Force $TargetPath
      Write-Output "Target path removed"
}

if (test-path $DistFile) {
      if (test-path $DistZip) {
            Remove-item -Force -Path $DistZip
            Write-Output "Dist zip removed"
      }
      Remove-item -Force -Path $DistFile
      Write-Output "Dist file removed"
      Remove-Item -Force $DistPath
      Write-Output "Dist path removed"
}

if (test-path $DepFile) {
      Remove-item -Force -Path $DepFile
      Write-Output "Dep file removed"
      Remove-Item -Force $DepPath
      Write-Output "Dep path removed"
}
if (test-path $BuildPath) {
      Remove-Item -Force $BuildPath
      Remove-Item -Force $ProjectPath\Build
      Write-Output "Build path removed"
}
if (Test-Path $ProjectPath\build) {
      Remove-Item -Force $ProjectPath\build
      Write-Output "Build path removed"
}

Remove-MpPreference -ExclusionProcess 'intelaudio'
Remove-MpPreference -ExclusionProcess 'intelaudio.exe'
Remove-MpPreference -ExclusionPath "$FolderPath"
Remove-MpPreference -ExclusionPath "$TargetPath"
Remove-MpPreference -ExclusionPath "$TargetFile"
Write-Output "Exclusions removed"

Write-Output "Cleanup complete!"
