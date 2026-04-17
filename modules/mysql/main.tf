locals {
  private_dns_zone_name = "${var.mysql_server_name}.private.mysql.database.azure.com"
}

resource "azurerm_private_dns_zone" "mysql" {
  name                = local.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "mysql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = var.vnet_prod_id
  registration_enabled  = false
  tags                  = var.tags
}

resource "azurerm_mysql_flexible_server" "this" {
  name                   = var.mysql_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password

  backup_retention_days        = 7
  delegated_subnet_id          = var.subnet_mysql_id
  private_dns_zone_id          = azurerm_private_dns_zone.mysql.id

  sku_name   = var.mysql_sku_name
  version    = var.mysql_version

    storage {
    size_gb = var.mysql_storage_gb
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql
  ]

  tags = var.tags
}

resource "azurerm_mysql_flexible_database" "this" {
  name                = var.mysql_database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

resource "azurerm_mysql_flexible_server_configuration" "timezone" {
  name                = "time_zone"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name
  value               = "-05:00"
}

resource "azurerm_mysql_flexible_server_configuration" "max_connections" {
  name                = "max_connections"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name
  value               = "100"
}

resource "azurerm_mysql_flexible_server_configuration" "wait_timeout" {
  name                = "wait_timeout"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name
  value               = "300"
}