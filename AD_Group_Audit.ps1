###
# Used to get a large list of AD group members in a domain.
###

$session = New-PSSession -ComputerName "<IP>" -Credential $UserCredential
Invoke-Command $session -Scriptblock { Import-Module ActiveDirectory }
Import-PSSession -Session $session -module ActiveDirectory

$ou = "OU=Groups,DC=<name>,DC=<name>"

Get-ADGroup -Filter 'Name -like "*"' -SearchBase $ou -Properties * | Get-ADGroupMember -Filter 'Name -like "<DOMAIN>"' | select name | sort name | Export-Csv 'C:\auditlogs\GroupSimilarities.csv'
