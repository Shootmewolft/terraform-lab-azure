output "resource_group_name" {
  value = module.resource_group.resource_group_name
}

output "location" {
  value = module.resource_group.location
}

output "vnet_prod_name" {
  value = module.networking.vnet_prod_name
}

output "vnet_ctg_name" {
  value = module.networking.vnet_ctg_name
}

output "vnet_dmz_name" {
  value = module.networking.vnet_dmz_name
}

output "subnet_prd_id" {
  value = module.networking.subnet_prd_id
}

output "subnet_dev_qas_id" {
  value = module.networking.subnet_dev_qas_id
}

output "subnet_bastion_id" {
  value = module.networking.subnet_bastion_id
}

output "subnet_lan_id" {
  value = module.networking.subnet_lan_id
}

output "subnet_ctg_id" {
  value = module.networking.subnet_ctg_id
}

output "subnet_dmz_id" {
  value = module.networking.subnet_dmz_id
}

output "bastion_name" {
  value = module.bastion.bastion_name
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "admin_vm_name" {
  value = module.admin_vm.vm_name
}

output "admin_vm_private_ip" {
  value = module.admin_vm.private_ip
}

output "subnet_mysql_id" {
  value = module.networking.subnet_mysql_id
}

output "mysql_server_name" {
  value = module.mysql.mysql_server_name
}

output "mysql_fqdn" {
  value = module.mysql.mysql_fqdn
}

output "mysql_database_name" {
  value = module.mysql.mysql_database_name
}