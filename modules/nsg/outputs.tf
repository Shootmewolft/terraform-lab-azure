output "nsg_prd_id" {
  value = azurerm_network_security_group.prd.id
}

output "nsg_dev_qas_id" {
  value = azurerm_network_security_group.dev_qas.id
}

output "nsg_ctg_id" {
  value = azurerm_network_security_group.ctg.id
}

output "nsg_dmz_id" {
  value = azurerm_network_security_group.dmz.id
}

output "nsg_lan_id" {
  value = azurerm_network_security_group.lan.id
}

output "nsg_mysql_id" {
  value = azurerm_network_security_group.mysql.id
}