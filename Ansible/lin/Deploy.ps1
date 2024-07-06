param (
    [string]$esxiHost = $env:GITHUB_ESXIHOST,
    [string]$esxiUsername = $env:GITHUB_ESXIUSERNAME,
    [string]$esxiPasswordPlainText = $env:GITHUB_ESXIPASSWORD,
    [string]$vmName = $env:GITHUB_VMNAME,
    [string]$vmDatastore = $env:GITHUB_VMDATASTORE,
    [string]$fileName = $env:GITHUB_FILENAME,
    [string]$diskFormat = $env:GITHUB_DISKFORMAT,
    [switch]$Force
)

import-module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Fonction_Log.psm1"
import-module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Connect-ESXiServer.psm1"

Write-Log -Message "Debut du processus d'importation de la machine virtuelle..."

$esxiPassword = ConvertTo-SecureString $esxiPasswordPlainText -AsPlainText -Force

function Find-OVFFile {
    param (
        [string]$FileName
    )
    $foundOVFPath = $null
    if (Test-Path -Path "C:\$FileName" -PathType Leaf) {
        $foundOVFPath = "C:\$FileName"
        Write-Log -Message "Fichier OVF trouvé : $foundOVFPath"
    } else {
        Write-Log -Message "Fichier OVF introuvable."
    }
    return $foundOVFPath
}

function Import-VM {
    param (
        [string]$esxiHost,
        [string]$esxiUsername,
        [SecureString]$esxiPassword,
        [string]$vmName,
        [string]$vmOVFPath,
        [string]$vmDatastore,
        [switch]$Force
    )

    try {
        Write-Log -Message "Connexion à l'hote ESXi/vCenter..."
        Connect-ESXiServer

        $existingVM = Get-VM -Name $vmName -ErrorAction SilentlyContinue
        if ($existingVM) {
            Write-Log -Message "Arret et suppression de la machine virtuelle existante..."
            if ($existingVM.PowerState -eq 'PoweredOn') {
                Write-Log -Message "Arret de la machine virtuelle..."
                Stop-VM -VM $existingVM -Confirm:$false
            } else {
                Write-Log -Message "La machine virtuelle est deja arretee."
            }
            Remove-VM -VM $existingVM -DeleteFromDisk -Confirm:$false
        }

        Write-Log -Message "Importation de la machine virtuelle à partir du fichier OVF..."
        $datastore = Get-Datastore -Name $vmDatastore
        Import-VApp -Source $vmOVFPath -VMHost (Get-VMHost -Name $esxiHost) -Datastore $datastore -Name $vmName -DiskStorageFormat $diskFormat
        Write-Log -Message "Machine virtuelle '$vmName' importee avec succes."
    }
    catch {
        Write-Log -Message "Une erreur s'est produite lors de l'importation de la machine virtuelle : $_"
    }
    finally {
        DisConnect-ESXiServer -ESXiHost $esxiHost
    }
}

$vmOVFPath = Find-OVFFile -FileName $fileName

if ($null -ne $vmOVFPath) {
    $importParams = @{
        esxiHost = $esxiHost
        esxiUsername = $esxiUsername
        esxiPassword = $esxiPassword
        vmName = $vmName
        vmOVFPath = $vmOVFPath
        vmDatastore = $vmDatastore
        Force = $Force
    }
    Import-VM @importParams
    Write-Log -Message "Processus d'importation de la machine virtuelle termine."
} else {
    Write-Log -Message "Le chemin du fichier OVF n'a pas ete defini."
}
