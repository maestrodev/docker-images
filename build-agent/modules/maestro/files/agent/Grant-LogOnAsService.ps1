# Derived From:
# https://gist.githubusercontent.com/ned1313/9143039/raw/229f232d324da2640792e23847865378b7b22f66/Grant-LogOnAsService

param(
    [string] $user
    )

Set-Location 'C:\Windows\Temp'

#Get list of currently used SIDs
C:\Windows\System32\secedit /export /cfg tempexport.inf
$curSIDs = Select-String .\tempexport.inf -Pattern "SeServiceLogonRight"
$Sids = $curSIDs.line

$objUser = New-Object System.Security.Principal.NTAccount($user)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
if(!$Sids.Contains($strSID) -and !$sids.Contains($user)){
    $newSids = $sids + ",*$strSID"
    Write-Host "New Sids: $newSids"
    Get-Content ".\tempexport.inf" | ForEach-Object { if ($_ -match "^SeServiceLogonRight") { $newSids } else { $_ } } | Set-Content ".\tempimport.inf"
    C:\Windows\System32\secedit /import /db secedit.sdb /cfg ".\tempimport.inf"
    C:\Windows\System32\secedit /configure /db secedit.sdb

    C:\Windows\System32\gpupdate /force
}
else{
    Write-Host "No new sids"
}


del ".\tempimport.inf" -force -ErrorAction SilentlyContinue
del ".\secedit.sdb" -force -ErrorAction SilentlyContinue
del ".\tempexport.inf" -force

