###
# Used to send out a daily report of AD users with upcoming password expirations.
###

Unblock-File -Path "<file_path>"

$ADUser = Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False -and PasswordExpired -eq $False} –Properties "DisplayName","mail","msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property "Displayname","mail",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}

## Sorts the list by password expiration date

$List = $ADUser | Sort "ExpiryDate"

## Settings for sending out the email

$Date = Get-Date -displayhint date
$DateOnly = $Date.ToShortDateString()
$EmailSubject = "Password Expiration Report for $DateOnly"
$SMTPServer = "<name>"
$EmailFrom = "<email>"
$EmailTo = "<email>"
$MessageBody= "$($List|ConvertTo-HTML)"

## Command to send out the email to ITOps

$Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo
$Message.Subject = $EmailSubject
$Message.IsBodyHTML = $true
$Message.Body = $MessageBody | Out-String
$SMTP = New-Object Net.Mail.SmtpClient($SMTPServer)
$SMTP.Send($Message)
