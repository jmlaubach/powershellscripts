###
# Was used as a starting part of a test to delete empty folders.
###

$tdc="C:\Testing"
$dirs = gci $tdc -directory -recurse | Where { (gci $_.fullName).count -eq 0 } | select -expandproperty FullName
$dirs | Foreach-Object { Remove-Item $_ }
