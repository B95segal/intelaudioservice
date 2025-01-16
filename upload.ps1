$ProjectPath = "$env:USERPROFILE\hack\Intel-Audio\X64\Release"
$ProjectFile = "$ProjectPath\Intel Dynamic Audio Platform Service.exe"
$ProjectZip  = "$ProjectPath\Intel Dynamic Audio Platform Service.zip"
$ProjectScript = ".\ias.ps1"
$ProjectXml = ".\Start Thunderbolt audio service on boot if driver is up.xml"


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