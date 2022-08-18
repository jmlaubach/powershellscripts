###
# Rudimentary script for getting some NTFS permissions from a specific folder.
###

$OutFile = "<output_file_path>" # Insert folder path where you want to save your file and its name
$Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"
$FileExist = Test-Path $OutFile
If ($FileExist -eq $True) {Del $OutFile}
Add-Content -Value $Header -Path $OutFile
$RootPath = "<folder_to_audit>" # Insert your share path
$Folders = dir $RootPath -recurse | where {$_.psiscontainer -eq $true} 
Foreach ($Folder in $Folders){
    $ACLs = get-acl $Folder.fullname | ForEach-Object { $_.Access  }
    Foreach ($ACL in $ACLs){
    $OutInfo = $Folder.Fullname + "," + $ACL.IdentityReference  + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags
    Add-Content -Value $OutInfo -Filter 'IdentityReference -like "*"' -Path $OutFile
    }}
