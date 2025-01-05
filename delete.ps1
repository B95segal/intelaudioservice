Clear-Host
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
       $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
       Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
       Exit
      }
     }
     
     # Remainder of script here
      $FolderPath = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
      $ShortcutFile = "$FolderPath\IAAudIOSvc.lnk"
      $TargetPath = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\IAAudIOSvc"
      $TargetFile = "$TargetPath\IAAudIOSvc.exe"
      
      If(Test-Path $ShortcutFile) {
            Remove-Item -Force -Confirm $ShortcutFile
            Remove-MpPreference -ExclusionPath $FolderPath
      }

      if (test-path $TargetFile) {
            Remove-item -Force -Path $TargetFile
            Remove-MpPreference -ExclusionPath $TargetPath
            Remove-Item -Confirm -Force $TargetPath
      }

      

