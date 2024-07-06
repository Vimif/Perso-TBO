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

Write-Log -Message "Starting the VM import process..."

$esxiPassword = ConvertTo-SecureString $esxiPasswordPlainText -AsPlainText -Force

function Find-OVFFile {
    param (
        [string]$FileName
    )
    $searchResults = Get-ChildItem -Path C:\ -Filter $FileName -Recurse -ErrorAction Ignore -File
    if ($searchResults.Count -gt 0) {
        $foundOVFPath = $searchResults[0].FullName
        Write-Log -Message "Found OVF file: $foundOVFPath"
        return $foundOVFPath
    } else {
        Write-Log -Message "OVF file not found."
        return $null
    }
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
        Write-Log -Message "Connecting to ESXi/vCenter host..."
        Connect-ESXiServer

        $existingVM = Get-VM -Name $vmName -ErrorAction Ignore
        if ($existingVM) {
            Write-Log -Message "Stopping and deleting the existing VM..."
            if ($existingVM.PowerState -eq 'PoweredOn'){
                Write-Log -Message "Stopping the VM..."
                Stop-VM -VM $existingVM -Confirm:$false
            } else {
                Write-Log -Message "The VM is already stopped."
            }
            Remove-VM -VM $existingVM -DeleteFromDisk -Confirm:$false
        }

        Write-Log -Message "Importing the VM from the OVF file..."
        $datastore = Get-Datastore -Name $vmDatastore
        Import-VApp -Source $vmOVFPath -VMHost (Get-VMHost -Name $esxiHost) -Datastore $datastore -Name $vmName -DiskStorageFormat $diskFormat
        Write-Log -Message "VM '$vmName' imported successfully."
    }
    catch {
        Write-Log -Message "An error occurred while importing the VM: $_"
    }
    finally {
        Disconnect-ESXiServer -Host $esxiHost
    }
}

$vmOVFPath = Find-OVFFile -FileName $fileName

if ($null -ne $vmOVFPath) {
    Import-VM -esxiHost $esxiHost -esxiUsername $esxiUsername -esxiPassword $esxiPassword -vmName $vmName -vmOVFPath $vmOVFPath -vmDatastore $vmDatastore -Force:$Force
    Write-Log -Message "VM import process completed."
} else {
    Write-Log -Message "The OVF file path has not been defined."
}
