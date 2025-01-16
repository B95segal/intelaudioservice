$ProjectPath   = "$env:USERPROFILE\hack\Intel-Audio"
$ProjectFile   = "$ProjectPath\X64\Release\Intel Dynamic Audio Platform Service.exe"
$ProjectZip    = "$ProjectPath\X64\Release\Intel Dynamic Audio Platform Service.zip"
$ProjectXml    = "$ProjectPath\Intel Dynamic Audio Platform Service.xml"
$ProjectScript = "$ProjectPath\Intel Dynamic Audio Notification Service.ps1"
$ProjectEmail  = "$ProjectPath\Intel Dynamic Audio Notification Service.xml"
$ProjectES     = "$ProjectPath\Intel Dynamic Audio Notification Service.ps1"

if (Test-Path "$ProjectZip") {
  Remove-Item -Force -Path "$ProjectZip"
  Write-Output "Project zip removed"
}

Compress-Archive -Path "$ProjectFile" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectXml" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectScript" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectEmail" -DestinationPath "$ProjectZip" -Update
Compress-Archive -Path "$ProjectES" -DestinationPath "$ProjectZip" -Update

git add .
git status
git commit -m debug
git push origin main
Write-Host 'Files uploaded to git'
