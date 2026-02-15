AzureLocalScripts README

This set of scripts helps you create a local Hyper-V instance of Azure Local running in a
single Hyper-V virtual machine. 

Prerequisites:
1. Windows Server 2022 or Windows Server 2025 running Hyper-V
2. Enough RAM and CPU capacity to meet the current minimum requirements of Azure Local in Hyper-V for evaluation purposes
3. The Hyper V HGS Guardian feature is enabled. 
4. An active Azure Subscription
5. A copy of the latest ISO image for Azure Local (downloadable from within your subscription)

To use:
1. Open a PowerShell session with administrative privileges
2. Run the AzLocalConfigureHGSGuardian.ps1 to ensure the HGS guardian feature is properly configured. 
3. Edit AzLocalVMCreate.ps1 and edit the variables around machine parameters and the default switch to utilize. 
4. Run AzLocalVMCreate.ps1 and start the VM. Install the Azure Local OS. 
5. Edit the AzLocalVMConfigure.ps1 and edit the variables around your machine and network parameters. 
6. With the VM running, run AZLocalVMConfigure.ps1
7. After this has completed, you are ready to start the ARC registration process and then create an Azure Local instance. 

