#Display What Groups a User is Part of and When They Were Added

Import-Module ActiveDirectory

#Username you would like to search
$username = "username" 
$userobj = Get-ADUser $username 

#Active Directory Server To Connect To
$ActiveDirectoryServer = "domaincontroller.test.com"

Get-ADUser $userobj.DistinguishedName -Properties memberOf | 
Select-Object -ExpandProperty memberOf | 
ForEach-Object { 
Get-ADReplicationAttributeMetadata $_ -Server $ActiveDirectoryServer -ShowAllLinkedValues | 
Where-Object {$_.AttributeName -eq 'member' -and 
$_.AttributeValue -eq $userobj.DistinguishedName} | 
Select-Object FirstOriginatingCreateTime, Object, AttributeValue 
} | Sort-Object FirstOriginatingCreateTime -Descending | Out-GridView