'use strict'
const pulumi = require('@pulumi/pulumi')
const azure = require('@pulumi/azure')

const resourceGroup =
  new azure.core.ResourceGroup('resourceGroup')

const account = new azure.storage.Account('storage', {
  resourceGroupName: resourceGroup.name,
  accountTier: 'Standard',
  accountReplicationType: 'LRS'
})

const appServicePlan = new azure.appservice.Plan('myplan', {
  resourceGroupName: resourceGroup.name,
  location: resourceGroup.location,
  kind: 'App',
  sku: {
    tier: 'Basic',
    size: 'B1'
  }
})

const app = new azure.appservice.AppService('mywebsite', {
  resourceGroupName: resourceGroup.name,
  location: resourceGroup.location,
  appServicePlanId: appServicePlan.id
})

exports.connectionString = account.primaryConnectionString

