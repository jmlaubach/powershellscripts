## This script scrapes AD users and sends out a password expiration alert email to AD users with passwords expiring in 7 days.

Unblock-File -Path "C:\Powershell Scripts\AD_Pass_Expire_Alert.ps1"
Import-Module ActiveDirectory

## Gets all AD users and filters out users who are disabled, have a password that never expires, or have an expired password

$AllUsers = Get-ADUser -filter * -properties * | where {$_.Enabled -eq "True"} | where { $_.PasswordNeverExpires -eq $false } | where { $_.passwordexpired -eq $false }

## For each user in $AllUsers above, it will calculate the days till password expiration and send out an email only to those with a password expiring in 7 days.

foreach ($User in $AllUsers)
{
  $Name = (Get-ADUser "$User" | foreach { $_.Name})
  $Email = $User.emailaddress
  $PasswdSetDate = (Get-ADUser "$User" -properties * | foreach { $_.PasswordLastSet })
  $MaxPasswdAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge
  $ExpireDate = $PasswdSetDate + $MaxPasswdAge
  $Today = (Get-Date)
  $DaysToExpire = (New-TimeSpan -Start $Today -End $ExpireDate).Days
  $EmailSubject = "Password Expiry Notice - Your Account/VPN Password Expires in 7 days"
  $SMTPServer = "<server_IP>"
  $EmailFrom = "<helpdesk_email"
  $EmailTo = $Email
  $MessageBody="
  Dear $Name,
  <p> Your computer/VPN password expires in $DaysToExpire days. To change your password, ensure that you are connected to the VPN first if you are working off site. <br /></p>
  <p>Press CTRL+ALT+DEL together and click Change Password. This will NOT work if you are on a personal computer using just the VPN. Please contact <helpdesk_email> to have it reset.<br /></p>

<p>If you do not update your password in $DaysToExpire days you will not be able to log in to your account or VPN. <br /></p>

<p>If you need any help or your password expired, contact us via email at: <helpdesk_email>. <br /></p>

Sincerely, <br />
  IT Department <br />
  </p>"

 $Message = New-Object System.Net.Mail.MailMessage $EmailFrom, $EmailTo
 $Message.Subject = $EmailSubject
 $Message.IsBodyHTML = $true
 $Message.Body = $MessageBody | Out-String
 $SMTP = New-Object Net.Mail.SmtpClient($SMTPServer)

if ($DaysToExpire -eq 7) {
    $SMTP.Send($Message)
}
else {
    continue
    }
}
