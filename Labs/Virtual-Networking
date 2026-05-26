@description('Name of the virtual network')
param name string

@description('deployment location for the virtual network')
param location string

@description('address prefixes for the virtual network')
param addressPrefixes array

@description('subnets to create within the virtual network')
param subnets array


resource vnet 'Microsoft.Network/virtualNetworks@2024-10-01' ={
  name: name
  location: location
  properties: {
    addressSpace: {addressPrefixes: addressPrefixes}
    subnets: [
      for s in subnets : {
        name: s.name
        properties: {
          addressPrefix:s.prefix
        }
      }
    ]
  }
}





