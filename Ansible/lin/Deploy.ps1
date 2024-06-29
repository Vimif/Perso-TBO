param (
    [string]$esxiHost = $env:GITHUB_ESXIHOST,  # ESXi host IP address from GitHub secret/environment variable
    [string]$esxiUsername = $env:GITHUB_ESXIUSERNAME,  # ESXi host username from GitHub secret/environment variable
    [string]$esxiPasswordPlainText = $env:GITHUB_ESXIPASSWORD,  # ESXi host password (plaintext) from GitHub secret/environment variable
    [string]$vmName = $env:GITHUB_VMNAMEL,  # Name of the virtual machine from GitHub environment variable
    [string]$vmDatastore = $env:GITHUB_VMDATASTORE,  # Datastore where the virtual machine will be stored from GitHub environment variable
    [string]$fileName = $env:GITHUB_FILENAMEL,  # Name of the OVF file from GitHub environment variable
    [string]$diskFormat = $env:GITHUB_DISKFORMAT,  # Disk format for the virtual machine from GitHub environment variable
    [switch]$Force  # Optional switch to force the operation
)


import-module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Fonction_Log.psm1"
Write-Log -Message "Debut du processus d'importation de la machine virtuelle..."

# Convertir le mot de passe en SecureString
$esxiPassword = ConvertTo-SecureString $esxiPasswordPlainText -AsPlainText -Force

# Fonction pour confirmer la suppression d'une machine virtuelle existante
# function Confirm-Deletion {
#     param (
#         [string]$vmName
#     )
#     $confirmation = Read-Host "La machine virtuelle $vmName existe déjà. Voulez-vous la supprimer ? (O/N)"
#     return $confirmation -eq 'O'
# }

# Fonction pour trouver le fichier OVF
function Find-OVFFile {
    param (
        [string]$FileName
    )
    $searchResults = Get-ChildItem -Path C:\ -Filter $FileName -Recurse -ErrorAction SilentlyContinue -File
    if ($searchResults.Count -gt 0) {
        $foundOVFPath = $searchResults[0].FullName
        Write-Host "Fichier OVF trouvé : $foundOVFPath"
        return $foundOVFPath
    } else {
        Write-Host "Fichier OVF introuvable."
        return $null
    }
}

# Fonction pour importer la machine virtuelle
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
        Write-Host "Connexion à l'hote ESXi/vCenter..."
        $esxiCredential = New-Object System.Management.Automation.PSCredential ($esxiUsername, $esxiPassword)
        Connect-VIServer -Server $esxiHost -Credential $esxiCredential

        $existingVM = Get-VM -Name $vmName -ErrorAction SilentlyContinue
        if ($existingVM) {
            <#if (-not $Force -and -not (Confirm-Deletion -vmName $vmName)) {
                Write-Host "Opération annulée par l'utilisateur."
                return
            }#>
            Write-Host "Arret et suppression de la machine virtuelle existante..."
            if ($existingVM.PowerState -eq 'PoweredOn'){
                Write-Host "Arrêt de la machine virtuelle..."
                Stop-VM -VM $existingVM -Confirm:$false
            } else {
                Write-Host "La machine virtuelle est deja arretee."
            }
            Remove-VM -VM $existingVM -DeleteFromDisk -Confirm:$false
        }

        Write-Host "Importation de la machine virtuelle à partir du fichier OVF..."
        $datastore = Get-Datastore -Name $vmDatastore
        Import-VApp -Source $vmOVFPath -VMHost (Get-VMHost -Name $esxiHost) -Datastore $datastore -Name $vmName -DiskStorageFormat $diskFormat
        Write-Host "Machine virtuelle '$vmName' importee avec succes."
        Write-Log -Message "Machine virtuelle '$vmName' importee avec succes."
    }
    catch {
        Write-Host "Une erreur s'est produite lors de l'importation de la machine virtuelle : $_"
        Write-Log -Message "Une erreur s'est produite lors de l'importation de la machine virtuelle : $_"
    }
    finally {
        Disconnect-VIServer -Server $esxiHost -Confirm:$false
    }
}

# Trouver le fichier OVF avant de tenter d'importer la machine virtuelle
$vmOVFPath = Find-OVFFile -FileName $fileName

if ($null -ne $vmOVFPath) {
    Import-VM -esxiHost $esxiHost -esxiUsername $esxiUsername -esxiPassword $esxiPassword -vmName $vmName -vmOVFPath $vmOVFPath -vmDatastore $vmDatastore -Force:$Force
    Write-Log -Message "Processus d'importation de la machine virtuelle termine."
} else {
    Write-Host "Le chemin du fichier OVF n'a pas ete defini."
    Write-Log -Message "Le chemin du fichier OVF n'a pas ete defini."
}