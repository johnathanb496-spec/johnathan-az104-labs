param location string
param vnet object
param storageAccountName string
param nsg object

var nsgAttachments = [
{
      vnetName:vnet.name
      subnetName:vnet.subnets[0].name
      addressPrefix:vnet.subnets[0].prefix
}
{
      vnetName:vnet.name
      subnetName:vnet.subnets[1].name
      addressPrefix:vnet.subnets[1].prefix
}
]

module devnet 'modules/network/vnet.bicep' = { 
   name: 'dev-network'
   params: { 
    name:vnet.name
    location: location
    addressPrefixes:vnet.addressPrefixes
    subnets:vnet.subnets
   }  
}

module storage 'modules/storage/storageAccount.bicep' = { 
    name: 'stcloudhublearningdeveus'
    params: { 
      name:storageAccountName
      location: location
    }
}


module sharednsg 'modules/security/nsg.bicep' = { 
   name: 'nsg-az104-shared-eus-01'
   params: { 
      location:location
      name:nsg.name
      rules:nsg.rules
      attachments:nsgAttachments
   }
}
