$VMName = "AzL51M"
$VSwitchName = "PeteyPie Virtual Switch"

Add-VmNetworkAdapter -VmName $VMName -Name "NIC1"
Add-VmNetworkAdapter -VmName $VMName -Name "NIC2"
Add-VmNetworkAdapter -VmName $VMName -Name "NIC3"
Add-VmNetworkAdapter -VmName $VMName -Name "NIC4"

Get-VmNetworkAdapter -VmName $VMName |Connect-VmNetworkAdapter -SwitchName $VSwitchName

Get-VmNetworkAdapter -VmName $VMName |Set-VmNetworkAdapter -MacAddressSpoofing On

Get-VmNetworkAdapter -VmName $VMName |Set-VMNetworkAdapterVlan -Trunk -NativeVlanId 0 -AllowedVlanIdList 0-1000

$owner = Get-HgsGuardian UntrustedGuardian
$kp = New-HgsKeyProtector -Owner $owner -AllowUntrustedRoot
Set-VMKeyProtector -VMName $VMName -KeyProtector $kp.RawData

Enable-VmTpm -VMName $VMName

Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true