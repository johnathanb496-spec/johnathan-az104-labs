@description('Storage account name (3-24 lowercase letters and numbers)')
param name string

@description('Deployment location, e.g. eastus')
param location string

resource sa 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name : name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
