resource azurerm_resource_group "funcs" {
  name = "ufst-funcs-rg"
  location = "westus2"
}

resource azurerm_storage_account "funcs" {
  name = "ufstfuncs"
  resource_group_name = azurerm_resource_group.funcs.name
  location = azurerm_resource_group.funcs.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource azurerm_app_service_plan "funcs" {
  name = "ufst-funcs-asp"
  location = azurerm_resource_group.funcs.location
  resource_group_name = azurerm_resource_group.funcs.name
  kind = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  # tags = {
  #   environment = "production"
  #   suite = "told"
  # }
}

resource azurerm_function_app "told" {
  name = "told-fa"
  location = azurerm_resource_group.funcs.location
  resource_group_name = azurerm_resource_group.funcs.name
  app_service_plan_id = azurerm_app_service_plan.funcs.id
  storage_connection_string = azurerm_storage_account.funcs.primary_connection_string
}
