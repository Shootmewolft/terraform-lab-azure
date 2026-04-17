output "mysql_server_id" {
  value = azurerm_mysql_flexible_server.this.id
}

output "mysql_server_name" {
  value = azurerm_mysql_flexible_server.this.name
}

output "mysql_fqdn" {
  value = azurerm_mysql_flexible_server.this.fqdn
}

output "mysql_database_name" {
  value = azurerm_mysql_flexible_database.this.name
}