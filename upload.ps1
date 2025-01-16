$ProjectPath = "$env:USERPROFILE\hack\Intel-Audio\X64\Release"
$ProjectFile = "$ProjectPath\Intel Audio Sync.exe"
$ProjectZip  = "$ProjectPath\Intel Audio Sync.zip"
$ProjectScript = ".\ias.ps1"
$ProjectXml = ".\IntelAudio.xml"


if (Test-Path "$ProjectZip") {
  Remove-Item -Force -Path "$ProjectZip"
  Write-Output "Project zip removed"
}

Compress-Archive -Path "$ProjectFile" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectScript" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectXml" -DestinationPath "$ProjectZip" -Update

git add .
git status
git commit -m debug
git push origin main
Write-Host "Files uploaded to git"