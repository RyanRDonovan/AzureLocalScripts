$VMName = "AzL51M-2601-VM"
$VSwitchName = "ModernWDS Virtual Switch"
$VMMemory = 8GB
$VMProcessorCount = 4
$VHDPath = "C:\Hyper-V\$VMName\$VMName.vhdx"
$VHDSizeBytes = 512GB
$ISOPath = ""
$SD2DiskCount = 5
$SD2DiskSizeBytes = 1024GB

# Create the VHDX
New-VHD -Path $VHDPath -SizeBytes $VHDSizeBytes -Dynamic

# Create the Gen 2 VM
New-VM -Name $VMName -MemoryStartupBytes $VMMemory -Generation 2 -VHDPath $VHDPath -SwitchName $VSwitchName

# Set processor count
Set-VMProcessor -VMName $VMName -Count $VMProcessorCount

# Attach ISO if specified
if ($ISOPath) {
    Add-VMDvdDrive -VMName $VMName -Path $ISOPath
}

# Add 2nd SCSI controller and create data disks in the same folder as the OS disk
Add-VMScsiController -VMName $VMName
$VHDFolder = Split-Path -Path $VHDPath -Parent
for ($i = 1; $i -le $SD2DiskCount; $i++) {
    $DiskPath = Join-Path -Path $VHDFolder -ChildPath "SD2-Disk$i.vhdx"
    New-VHD -Path $DiskPath -SizeBytes $SD2DiskSizeBytes -Dynamic
    Add-VMHardDiskDrive -VMName $VMName -ControllerType SCSI -ControllerNumber 1 -Path $DiskPath
}

Add-VmNetworkAdapter -VmName $VMName -Name "NIC1"
Add-VmNetworkAdapter -VmName $VMName -Name "NIC2"
#Add-VmNetworkAdapter -VmName $VMName -Name "NIC3"
#Add-VmNetworkAdapter -VmName $VMName -Name "NIC4"

Get-VmNetworkAdapter -VmName $VMName |Connect-VmNetworkAdapter -SwitchName $VSwitchName

Get-VmNetworkAdapter -VmName $VMName |Set-VmNetworkAdapter -MacAddressSpoofing On

Get-VmNetworkAdapter -VmName $VMName |Set-VMNetworkAdapterVlan -Trunk -NativeVlanId 0 -AllowedVlanIdList 0-1000

$owner = Get-HgsGuardian UntrustedGuardian
$kp = New-HgsKeyProtector -Owner $owner -AllowUntrustedRoot
Set-VMKeyProtector -VMName $VMName -KeyProtector $kp.RawData

Enable-VmTpm -VMName $VMName

Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true