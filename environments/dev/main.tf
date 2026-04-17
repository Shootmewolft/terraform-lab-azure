module "resource_group" {
  source = "../modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "networking" {
  source = "../modules/networking"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  project_name        = var.project_name
  environment         = var.environment
  tags                = var.tags

  vnet_prod_cidr = var.vnet_prod_cidr
  vnet_ctg_cidr  = var.vnet_ctg_cidr
  vnet_dmz_cidr  = var.vnet_dmz_cidr

  subnet_prd_cidr     = var.subnet_prd_cidr
  subnet_dev_qas_cidr = var.subnet_dev_qas_cidr
  subnet_bastion_cidr = var.subnet_bastion_cidr
  subnet_lan_cidr     = var.subnet_lan_cidr
  subnet_ctg_cidr     = var.subnet_ctg_cidr
  subnet_dmz_cidr     = var.subnet_dmz_cidr
}