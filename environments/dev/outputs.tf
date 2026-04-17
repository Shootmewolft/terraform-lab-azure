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