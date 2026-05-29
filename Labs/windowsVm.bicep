@description('URI to the scritp file')
@secure()
param scriptUri  string

@description('command to execute on the vm after file is downloaded')
param scriptCommand string = 'powershell -ExecutionPolicy Bypass -File.\\setup-iis.ps1'

@description('Azure Region')
param location string

@description('VM Size, e.g. Standard_D2s_v3')
param vmSize string

@description('adminusername')
param adminUserName string = 'azureadmin'

@secure()
@description('adminpassword (or use keyvault reference in parameter file)')
param adminPassword string

param baseName string

@description('how many VMs to create')
param count int

@description('Target Subnet Resource ID')
param subnetId string

var indexes = [for i in range(1, count): i]
var vmNames = [for i in indexes: 'vm-${baseName}-${i}']
var nicNames = [for i in indexes: 'nic-${baseName}-${i}']

resource nics 'Microsoft.Network/networkInterfaces@2025-05-01' = [for (nicName, i) in nicNames: {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig-01'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
        }
      }
    ]
  }
}]

resource vms 'Microsoft.Compute/virtualMachines@2024-07-01' = [for (vmName, i) in vmNames: {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUserName
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nics[i].id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
}]

resource cse 'Microsoft.Compute/virtualMachines/extensions@2021-04-01' = [
  for i  in  range (0, length(vmNames)): {
  name: 'cse-init'            
  parent: vms[i]                       
  location:  location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
  
    settings: {
      fileUris: [
        'ENTER SAS LINK HERE'
      ]
    }
  
    protectedSettings: {
      commandToExecute: scriptCommand
    }
  }
}

]

