# Spécifiez les informations de connexion à l'hôte ESXi
$esxiHost = "192.168.127.128"
$esxiUsername = "root"
$esxiPassword = "Password5*"

# Spécifiez les informations de la machine virtuelle
$vmName = "VM_Winwdows"
$vmDatastore = "datastore1"
$vmISOPath = "[${vmDatastore}] ISO/Win11_23H2_French_x64v2.iso"

# Spécifiez la quantité de RAM pour la machine virtuelle (4GB)
$vmMemoryGB = 4

# Connexion à l'hôte ESXi
$esxiSession = Connect-VIServer -Server $esxiHost -Username $esxiUsername -Password $esxiPassword

# Vérifier si la machine virtuelle existe déjà
$existingVM = Get-VM -Name $vmName -ErrorAction SilentlyContinue

# Supprimer la machine virtuelle si elle existe déjà
if ($existingVM) {
    Stop-VM -VM $existingVM -Confirm:$false
    Remove-VM -VM $existingVM -DeleteFromDisk -Confirm:$false
}

# Création de la nouvelle machine virtuelle avec la quantité de RAM spécifiée
$vmSpec = New-VM -Name $vmName -Datastore $vmDatastore -VMHost $esxiHost -DiskStorageFormat Thin -MemoryGB $vmMemoryGB -NumCpu 4 -DiskGB 64 -NetworkName "VM Network"
$vm = Get-VM -Name $vmName

# Ajout du lecteur CD/DVD virtuel
$cdDrive = New-CDDrive -VM $vm -ISOPath $vmISOPath -StartConnected:$true

# Démarrage de la machine virtuelle
Start-VM -VM $vm

# Déconnexion de l'hôte ESXi
Disconnect-VIServer -Server $esxiHost -Confirm:$false