
###
# Test script used to configure connection to Google Workspace and get a list of group members
###

$ConfigName = "GSuite"
$P12KeyPath = "<path>"
$AppEmail = "<app_email"
$AdminEmail = "<email>"
$CustomerID = "<id>"
$Domain = "<domain_name>"
$ServiceAccountClientID = "<id_number>"

Set-PSGSuiteConfig -ConfigName $ConfigName `
-P12KeyPath $P12KeyPath -AppEmail $AppEmail `
-AdminEmail $AdminEmail -CustomerID $CustomerID `
-Domain $Domain  -ServiceAccountClientID $ServiceAccountClientID

Get-GSGroup | Get-GSGroupMember | select Group,Email | Export-Csv -Path "C:\auditlogs\distrogroupmembers2.csv"
