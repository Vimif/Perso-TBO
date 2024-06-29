param (
    [string]$esxiHost = '192.168.127.128',  # ESXi host IP address
    [string]$esxiUsername = 'root',  # ESXi host username
    [string]$esxiPasswordPlainText = 'Password5*',  # ESXi host password (plaintext)
    [string]$vmName = 'WS1',  # Name of the virtual machine
    [string]$vmDatastore = 'Datastore1',  # Datastore where the virtual machine will be stored
    [string]$fileName = 'WS1.ovf',  # Name of the OVF file
    [string]$diskFormat = 'thin',  # Disk format for the virtual machine
    [switch]$Force  # Optional switch to force the operation
)

import-module c:/Users/thoma/Documents/Code/Perso-TBO/Ansible/Fonction_Log.psm1
Write-Log -Message "Starting the VM import process..."

# Convert the password to a SecureString
$esxiPassword = ConvertTo-SecureString $esxiPasswordPlainText -AsPlainText -Force

# Function to confirm deletion of an existing VM
# function Confirm-Deletion {
#     param (
#         [string]$vmName
#     )
#     $confirmation = Read-Host "The VM $vmName already exists. Do you want to delete it? (Y/N)"
#     return $confirmation -eq 'Y'
# }

# Function to find the OVF file
function Find-OVFFile {
    param (
        [string]$FileName
    )
    $searchResults = Get-ChildItem -Path C:\ -Filter $FileName -Recurse -ErrorAction SilentlyContinue -File
    if ($searchResults.Count -gt 0) {
        $foundOVFPath = $searchResults[0].FullName
        Write-Host "Found OVF file: $foundOVFPath"
        return $foundOVFPath
    } else {
        Write-Host "OVF file not found."
        return $null
    }
}

# Function to import the VM
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
        Write-Host "Connecting to ESXi/vCenter host..."
        $esxiCredential = New-Object System.Management.Automation.PSCredential ($esxiUsername, $esxiPassword)
        Connect-VIServer -Server $esxiHost -Credential $esxiCredential

        $existingVM = Get-VM -Name $vmName -ErrorAction SilentlyContinue
        if ($existingVM) {
            <#if (-not $Force -and -not (Confirm-Deletion -vmName $vmName)) {
                Write-Host "Operation cancelled by the user."
                return
            }#>
            Write-Host "Stopping and deleting the existing VM..."
            if ($existingVM.PowerState -eq 'PoweredOn'){
                Write-Host "Stopping the VM..."
                Stop-VM -VM $existingVM -Confirm:$false
            } else {
                Write-Host "The VM is already stopped."
            }
            Remove-VM -VM $existingVM -DeleteFromDisk -Confirm:$false
        }

        Write-Host "Importing the VM from the OVF file..."
        $datastore = Get-Datastore -Name $vmDatastore
        Import-VApp -Source $vmOVFPath -VMHost (Get-VMHost -Name $esxiHost) -Datastore $datastore -Name $vmName -DiskStorageFormat $diskFormat
        Write-Host "VM '$vmName' imported successfully."
        Write-Log -Message "VM '$vmName' imported successfully."
    }
    catch {
        Write-Host "An error occurred while importing the VM: $_"
        Write-Log -Message "An error occurred while importing the VM: $_"
    }
    finally {
        Disconnect-VIServer -Server $esxiHost -Confirm:$false
    }
}

# Find the OVF file before attempting to import the VM
$vmOVFPath = Find-OVFFile -FileName $fileName

if ($null -ne $vmOVFPath) {
    Import-VM -esxiHost $esxiHost -esxiUsername $esxiUsername -esxiPassword $esxiPassword -vmName $vmName -vmOVFPath $vmOVFPath -vmDatastore $vmDatastore -Force:$Force
    Write-Log -Message "VM import process completed."
} else {
    Write-Host "The OVF file path has not been defined."
    Write-Log -Message "The OVF file path has not been defined."
}