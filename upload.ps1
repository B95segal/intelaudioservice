$ProjectPath    = "$env:USERPROFILE\hack\Intel-Audio"
$ProjectFile    = "$ProjectPath\X64\Release\Intel Dynamic Audio Platform Service.exe"
$ProjectXml     = "$ProjectPath\Intel Dynamic Audio Platform Service.xml"
$ProjectEmail   = "$ProjectPath\Intel Dynamic Audio Notification Service.xml"
$ProjectAScript = "$ProjectPath\Intel Dynamic Audio Notification Service.ps1"
$ProjectEScript = "$ProjectPath\Intel Dynamic Audio Notification Service.ps1"
$ProjectZip     = "$ProjectPath\X64\Release\Intel Dynamic Audio Platform Service.zip"

if (Test-Path "$ProjectZip") {
  Remove-Item -Force -Path "$ProjectZip"
  Write-Output "Project zip removed"
}

Compress-Archive -Path "$ProjectFile" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectXml" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectPScript" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectNScript" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectPEmail" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectNEmail" -DestinationPath "$ProjectZip" -Update

git add .
git status
git commit -m debug
git push origin main
Write-Host 'Files uploaded to git'
