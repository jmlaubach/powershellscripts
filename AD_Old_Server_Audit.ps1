###
# Used to gather a list of servers from a specific OU that haven't been logged into in over a year.
###

$session = New-PSSession -ComputerName "<name/IP>" -Credential $UserCredential
Invoke-Command $session -Scriptblock { Import-Module ActiveDirectory }
Import-PSSession -Session $session -module ActiveDirectory

# Number of days since computer authenticated to the domain
$days = "-365"

# OU to search for computers
$ou = "OU=<name>,DC=<name>,DC=<name>,DC=<name>"

Get-ADComputer -Filter 'Name -like "*" -and enabled -eq "true"' -SearchBase $ou -Properties LastLogonDate | 
where {$_.LastLogonDate -le [DateTime]::Today.AddDays($days) -and ($_.lastlogondate -ne $null) } | select name | 
sort name | Export-Csv 'C:\auditlogs\old_server_365day.csv' -NoTypeInformation

# OU to search for computers
$ou2 = "OU=<name>,DC=<name>,DC=<name>,DC=<name>"

Get-ADComputer -Filter 'Name -like "*" -and enabled -eq "true"' -SearchBase $ou2 -Properties LastLogonDate | 
where {$_.LastLogonDate -le [DateTime]::Today.AddDays($days) -and ($_.lastlogondate -ne $null) } | select name | 
sort name | Export-Csv 'C:\auditlogs\old_server2_365day.csv' -NoTypeInformation
