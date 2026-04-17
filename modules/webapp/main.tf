locals {
  app_service_plan_name = "asp-${var.project_name}-${var.environment}"
}

resource "azurerm_service_plan" "this" {
  name                = local.app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.app_service_sku
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                      = var.web_app_name
  location                  = var.location
  resource_group_name       = var.resource_group_name
  service_plan_id           = azurerm_service_plan.this.id
  virtual_network_subnet_id = var.subnet_webapp_id
  tags                      = var.tags

  site_config {
    application_stack {
      php_version = "8.2"
    }
  }

  app_settings = {
    "MYSQL_HOST"     = var.mysql_fqdn
    "MYSQL_DATABASE" = var.mysql_database_name
    "MYSQL_USER"     = var.mysql_admin_username
  }

  connection_string {
    name  = "MySQLConnection"
    type  = "MySql"
    value = "Server=${var.mysql_fqdn};Database=${var.mysql_database_name};Uid=${var.mysql_admin_username};Pwd=${var.mysql_admin_password};SslMode=Required"
  }
}
