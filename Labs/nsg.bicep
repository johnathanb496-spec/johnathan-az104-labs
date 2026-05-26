param name string
param location string
@description('Array of security rules, each like the ARM schema')
param rules array

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-10-01'={ 
  name: name
  location: location
  properties: { 
    securityRules: [ 
      for r in rules: r
    ]
  }
}
