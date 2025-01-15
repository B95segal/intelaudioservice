Write-Host "Uploading files to git"
git add .
git status
git commit -m debug
git push origin main
Write-Host "Files uploaded to git"