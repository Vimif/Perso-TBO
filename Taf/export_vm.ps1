<#
    Synopsis  : export VMs depuis ESXI vers machine local
    Author    : T0275335
    Date      : 08/04/2024
#>


# Variables génériques
$serveurAdresse = "172.16.120.1"
$nomUtilisateur = "root"
$motDePasse = "Password5*"

# Se connecter au serveur vCenter
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -DefaultVIServerMode Multiple -Confirm:$false -Scope Session
Connect-VIServer -Server $serveurAdresse -User $nomUtilisateur -Password $motDePasse

Get-VM | Select-Object -Property Name | Format-Table

$name = Read-Host "Entrer les noms des VMs à exporter, séparer par un espace "
$name = $name.split(' ')

try {
    foreach ($vm in $name)

    {
        Write-host "Exporting vm : $vm"

        # if (Get-CDDrive -VM $vm -ErrorAction SilentlyContinue) {

        #     Remove-CDDrive `
        #         -CD (Get-CDDrive -VM $vm) `
        #         -Confirm:$false            
        # }
        
        Stop-VM -VM $vm -Confirm:$false -ErrorAction SilentlyContinue
        Get-VM -Name $vm | Export-VM -Destination "D:\" -Format OVA -RunAsync -Force
    }
}
catch {
    Write-host "Unknow error : $($_)"
    Exit
}
