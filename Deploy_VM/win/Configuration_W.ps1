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

Connect-ESXiServer

$vm = Get-VM -Name $vmName | Select-Object -Property NumCPU, MemoryGB
$disk_config = Get-HardDisk -VM $vm | Select-Object -First 1

Write-Log -Message "NumCPU: $($vm.NumCPU), MemoryGB: $($vm.MemoryGB), Disk: $($disk_config.CapacityGB)"

if ($vm.NumCPU -eq $cpu -and $vm.MemoryGB -eq $Memory -and $disk_config.CapacityGB -eq $disk) {
    Write-Log -Message "The VM $vmName is good"
} else {
    Write-Log -Message "The VM $vmName is not good"
    Write-Log -Message "Updating the VM $vmName configuration..."

    $vmParams = @{
        VM = $vm
        NumCPU = $cpu
        MemoryGB = $Memory
        Confirm = $false
    }
    set-vm @vmParams

    $diskParams = @{
        HardDisk = $disk_config
        CapacityGB = $disk
        Confirm = $false
    }
    Set-HardDisk @diskParams
}