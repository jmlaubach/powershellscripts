###
# Used to gather a list of servers from two different OUs in AD and output csv file.
###

$session = New-PSSession -ComputerName "<name/IP>" -Credential $UserCredential
Invoke-Command $session -Scriptblock { Import-Module ActiveDirectory }
Import-PSSession -Session $session -module ActiveDirectory

$ou2 = "OU=<name>,DC=in,DC=<name>,DC=<name>"
$ou = "OU=<name>,DC=in,DC=<name>,DC=<name>"

Get-ADComputer -Filter 'Name -like "*" -and enabled -eq "true"' -SearchBase $ou | select name | sort name | Export-Csv 'C:\auditlogs\<file_name>.csv' -NoTypeInformation

Get-ADComputer -Filter 'Name -like "*" -and enabled -eq "true"' -SearchBase $ou2 | select name | sort name | Export-Csv 'C:\auditlogs\<file_name>.csv' -NoTypeInformation
