$ProjectPath = "$env:USERPROFILE\hack\Intel-Audio\dist"
$ProjectFile = "$ProjectPath\Intel Audio.exe"
$ProjectZip  = "$ProjectPath\Intel Audio.zip"
$DistPath    = "$env:USERPROFILE\AppData\Intel Corporation\Intel Audio"

if (Test-Path "$ProjectFile") {
  Remove-Item -Force -Path "$ProjectFile"
  Write-Output "Project file removed"
}

if (Test-Path "$ProjectZip") {
  Remove-Item -Force -Path "$ProjectZip"
  Write-Output "Project zip removed"
}

pyinstaller --onefile --clean --debug all --nowindowed --noconsole -i .\icon.ico --runtime-tmpdir "$DistPath" '.\Intel Audio.py'

Compress-Archive -Path "$ProjectFile" -DestinationPath "$ProjectZip"
Write-Output - "Project zip created"

Write-Host "Add files to git"
git add .

Write-Host "Commit files to git"
git commit -m recompiled

Write-Host "Push files to git"
git push origin main

Write-Host "Build complete!"