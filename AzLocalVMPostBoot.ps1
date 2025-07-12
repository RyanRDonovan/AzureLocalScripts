$VMName = "AzL51M-VM"
$ManagementIP = "192.168.2.115"
$GatewayIP = "192.168.2.1"
$DNSIP = "192.168.2.3"

echo "Parameters"
echo "VMName =  $VMName"
echo "ManagementIP = $ManagementIP"
echo "GatewayIP = $GatewayIP"
echo "DNSIP = $DNSIP"
echo ""

$Node1macNIC1 = Get-VMNetworkAdapter -VMName $VMName -Name "NIC1"
$Node1macNIC1.MacAddress
$Node1finalmacNIC1=$Node1macNIC1.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
$Node1finalmacNIC1

$Node1macNIC2 = Get-VMNetworkAdapter -VMName $VMName -Name "NIC2"
$Node1macNIC2.MacAddress
$Node1finalmacNIC2=$Node1macNIC2.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
$Node1finalmacNIC2

$Node1macNIC3 = Get-VMNetworkAdapter -VMName $VMName -Name "NIC3"
$Node1macNIC3.MacAddress
$Node1finalmacNIC3=$Node1macNIC3.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
$Node1finalmacNIC3

$Node1macNIC4 = Get-VMNetworkAdapter -VMName $VMName -Name "NIC4"
$Node1macNIC4.MacAddress
$Node1finalmacNIC4=$Node1macNIC4.MacAddress|ForEach-Object{($_.Insert(2,"-").Insert(5,"-").Insert(8,"-").Insert(11,"-").Insert(14,"-"))-join " "}
$Node1finalmacNIC4

$cred = Get-Credential
echo "Credential Set"

Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {param($Node1finalmacNIC1) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC1} | Rename-NetAdapter -NewName "NIC1"} -ArgumentList $Node1finalmacNIC1
Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {param($Node1finalmacNIC2) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC2} | Rename-NetAdapter -NewName "NIC2"} -ArgumentList $Node1finalmacNIC2
Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {param($Node1finalmacNIC3) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC3} | Rename-NetAdapter -NewName "NIC3"} -ArgumentList $Node1finalmacNIC3
Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {param($Node1finalmacNIC4) Get-NetAdapter -Physical | Where-Object {$_.MacAddress -eq $Node1finalmacNIC4} | Rename-NetAdapter -NewName "NIC4"} -ArgumentList $Node1finalmacNIC4
echo "MACs Renamed"

Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC1" -Dhcp Disabled}
Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC2" -Dhcp Disabled}
Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC3" -Dhcp Disabled}
Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {Set-NetIPInterface -InterfaceAlias "NIC4" -Dhcp Disabled}
echo "DHCP Disabled"


Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {param($ManagementIP, $GatewayIP) New-NetIPAddress -InterfaceAlias "NIC1" -IPAddress $ManagementIP -PrefixLength 24 -AddressFamily IPv4 -DefaultGateway $GatewayIP} -ArgumentList $ManagementIP, $GatewayIP
echo "Static IP Set"

Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {param($DNSIP) Set-DnsClientServerAddress -InterfaceAlias "NIC1" -ServerAddresses $DNSIP} -ArgumentList $DNSIP
echo "DNS Set"

Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All }
echo "Hyper-V Enabled"

Invoke-Command -VMName $VMName -Credential $cred -ScriptBlock {Install-WindowsFeature -Name Hyper-V -IncludeManagementTools}
echo "Hyper-V Installed"