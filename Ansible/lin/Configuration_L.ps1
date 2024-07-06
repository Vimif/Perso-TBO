param (
    [string]$esxiHost = $env:GITHUB_ESXIHOST,
    [string]$esxiUsername = $env:GITHUB_ESXIUSERNAME,
    [string]$esxiPassword = $env:GITHUB_ESXIPASSWORD,
    [string]$vmName = $env:GITHUB_VMNAME,
    [string]$vmDatastore = $env:GITHUB_VMDATASTORE,
    [string]$fileName = $env:GITHUB_FILENAME,
    [string]$diskFormat = $env:GITHUB_DISKFORMAT,
    [string]$cpu = $env:GITHUB_CPU,
    [string]$Memory = $env:GITHUB_MEMORY,
    [string]$disk = $env:GITHUB_DISK,
    [switch]$Force
)

Import-Module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Fonction_Log.psm1"
Import-Module "C:\Users\thoma\Documents\GitHub\Perso-TBO\module\Connect-ESXiServer.psm1"

Connect-ESXiServer

$vmParams = @{
    Name = $vmName
    Property = 'NumCPU', 'MemoryGB'
    ErrorAction = 'Stop'
}

$vm = Get-VM @vmParams
$config = $vm | Select-Object -Property NumCPU, MemoryGB

$diskParams = @{
    VM = $vm
    Property = 'CapacityGB'
    First = 1
    ErrorAction = 'Stop'
}

$disk_config = Get-HardDisk @diskParams

Write-Log -Message "NumCPU: $($config.NumCPU), MemoryGB: $($config.MemoryGB), Disk: $($disk_config.CapacityGB)"

if ($config.NumCPU -eq $cpu -and $config.MemoryGB -eq $Memory -and $disk_config.CapacityGB -eq $disk) {
    Write-Log -Message "The VM $vmName is good"
} else {
    Write-Log -Message "The VM $vmName is not good"
    Write-Log -Message "Updating the VM $vmName configuration..."

    $vmParams['NumCPU'] = $cpu
    $vmParams['MemoryGB'] = $Memory
    Set-VM @vmParams -Confirm:$false

    $diskParams['CapacityGB'] = $disk
    Set-HardDisk @diskParams -Confirm:$false
}