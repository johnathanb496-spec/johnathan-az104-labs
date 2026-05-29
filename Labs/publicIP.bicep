@description ('Public IP address Name')
param name string

param location string

@description('SKU: Standard requrired for Bastion')
param sku string = 'standard'

param allocation string = 'static'

resource pip 'Microsoft.Network/publicIPAddresses@2024-10-01'={ 
  name:name
  location:location
  sku:{name:sku}
  properties:{publicIPAllocationMethod:'Static'}
}

output id string =pip.id
