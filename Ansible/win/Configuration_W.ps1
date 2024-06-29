param (
    [string]$esxiHost = $env:GITHUB_ESXIHOST,  # ESXi host IP address from GitHub secret/environment variable
    [string]$esxiUsername = $env:GITHUB_ESXIUSERNAME,  # ESXi host username from GitHub secret/environment variable
    [string]$esxiPassword = $env:GITHUB_ESXIPASSWORD,  # ESXi host password (plaintext) from GitHub secret/environment variable
    [string]$vmName = $env:GITHUB_VMNAME,  # Name of the virtual machine from GitHub environment variable
    [string]$vmDatastore = $env:GITHUB_VMDATASTORE,  # Datastore where the virtual machine will be stored from GitHub environment variable
    [string]$fileName = $env:GITHUB_FILENAME,  # Name of the OVF file from GitHub environment variable
    [string]$diskFormat = $env:GITHUB_DISKFORMAT,  # Disk format for the virtual machine from GitHub environment variable
    [switch]$Force  # Optional switch to force the operation
)

Import-Module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Fonction_Log.psm1"
Import-Module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Connect-ESXiServer.psm1"

Connect-ESXiServer

$config = get-vm -name $vmName | format-list 

if ($config.NumCPU -eq 4 -and $config.MemoryGB -eq 8) {
    Write-Log -Message "The VM $vmName is good"
} else {
    Write-Log -Message "The VM $vmName is not good"
}

Write-Log -Message "test"
