output "vnet_prod_name" {
  value = azurerm_virtual_network.prod.name
}

output "vnet_ctg_name" {
  value = azurerm_virtual_network.ctg.name
}

output "vnet_dmz_name" {
  value = azurerm_virtual_network.dmz.name
}

output "vnet_prod_id" {
  value = azurerm_virtual_network.prod.id
}

output "vnet_ctg_id" {
  value = azurerm_virtual_network.ctg.id
}

output "vnet_dmz_id" {
  value = azurerm_virtual_network.dmz.id
}

output "subnet_prd_id" {
  value = azurerm_subnet.prd.id
}

output "subnet_dev_qas_id" {
  value = azurerm_subnet.dev_qas.id
}

output "subnet_bastion_id" {
  value = azurerm_subnet.bastion.id
}

output "subnet_lan_id" {
  value = azurerm_subnet.lan.id
}

output "subnet_ctg_id" {
  value = azurerm_subnet.ctg.id
}

output "subnet_dmz_id" {
  value = azurerm_subnet.dmz.id
}

output "subnet_prd_name" {
  value = azurerm_subnet.prd.name
}

output "subnet_dev_qas_name" {
  value = azurerm_subnet.dev_qas.name
}

output "subnet_bastion_name" {
  value = azurerm_subnet.bastion.name
}

output "subnet_lan_name" {
  value = azurerm_subnet.lan.name
}

output "subnet_ctg_name" {
  value = azurerm_subnet.ctg.name
}

output "subnet_dmz_name" {
  value = azurerm_subnet.dmz.name
}