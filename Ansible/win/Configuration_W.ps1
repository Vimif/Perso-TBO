Import-Module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Fonction_Log.psm1"
Import-Module ".\Fonction_Log.psm1"
write-log -Message "test"
$vmName
# Import variables from another script
. "C:\Users\thoma\Documents\Code\Perso-TBO\Ansible\Deploy.ps1"
. ".\Fonction_Log.psm1"

write-log -Message "test"
$vmName
$vmUsername
$vmPassword