param (
    [string]$esxiHost = $env:GITHUB_ESXIHOST,  # ESXi host IP address from GitHub secret/environment variable
    [string]$esxiUsername = $env:GITHUB_ESXIUSERNAME,  # ESXi host username from GitHub secret/environment variable
    [string]$esxiPassword = $env:GITHUB_ESXIPASSWORD,  # ESXi host password (plaintext) from GitHub secret/environment variable
    [string]$vmName = $env:GITHUB_VMNAME,  # Name of the virtual machine from GitHub environment variable
    [string]$vmDatastore = $env:GITHUB_VMDATASTORE,  # Datastore where the virtual machine will be stored from GitHub environment variable
    [string]$fileName = $env:GITHUB_FILENAME,  # Name of the OVF file from GitHub environment variable
    [string]$diskFormat = $env:GITHUB_DISKFORMAT,  # Disk format for the virtual machine from GitHub environment variable
    [string]$cpu = $env:GITHUB_CPU, # Number of CPUs for the virtual machine from GitHub environment variable
    [string]$Memory = $env:GITHUB_MEMORY, # Amount of memory for the virtual machine from GitHub environment variable
    [string]$disk = $env:GITHUB_DISK, # Size of the disk for the virtual machine from GitHub environment variable
    [switch]$Force  # Optional switch to force the operation
)

Import-Module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Fonction_Log.psm1"
Import-Module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Connect-ESXiServer.psm1"

Connect-ESXiServer


$vm = Get-VM -Name $vmName
$config = Get-VM -Name $vmName | Select-Object -Property NumCPU, MemoryGB
$disk_config = Get-HardDisk -VM $vm | Select-Object -First 1 | Select-Object -Property CapacityGB

Write-Host "NumCPU: $($config.NumCPU), MemoryGB: $($config.MemoryGB), Disk: $($disk_config.CapacityGB)"

if ($config.NumCPU -eq $cpu -and $config.MemoryGB -eq $Memory -and $disk_config.CapacityGB -eq $disk) {
    Write-Log -Message "The VM $vmName is good"
} else {
    Write-Log -Message "The VM $vmName is not good"

    Write-Log -Message "Updating the VM $vmName configuration..."

    set-vm -VM $vm -NumCPU $cpu -MemoryGB $Memory -Confirm:$false
    Set-HardDisk -HardDisk $disk -CapacityGB $disk -Confirm:$false
}