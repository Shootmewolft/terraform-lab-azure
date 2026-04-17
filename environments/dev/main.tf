module "resource_group" {
  source = "../../modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "networking" {
  source = "../../modules/networking"

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
  subnet_mysql_cidr   = var.subnet_mysql_cidr
  subnet_webapp_cidr  = var.subnet_webapp_cidr
}

module "nsg" {
  source = "../../modules/nsg"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  project_name        = var.project_name
  environment         = var.environment
  tags                = var.tags

  subnet_prd_id     = module.networking.subnet_prd_id
  subnet_dev_qas_id = module.networking.subnet_dev_qas_id
  subnet_ctg_id     = module.networking.subnet_ctg_id
  subnet_dmz_id     = module.networking.subnet_dmz_id
  subnet_lan_id     = module.networking.subnet_lan_id
  subnet_mysql_id   = module.networking.subnet_mysql_id
  subnet_webapp_id  = module.networking.subnet_webapp_id
}

module "bastion" {
  source = "../../modules/bastion"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  project_name        = var.project_name
  environment         = var.environment
  tags                = var.tags

  subnet_bastion_id = module.networking.subnet_bastion_id
}

module "admin_vm" {
  source = "../../modules/vm"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  project_name        = var.project_name
  environment         = var.environment
  tags                = var.tags

  subnet_id      = module.networking.subnet_lan_id
  vm_name        = var.admin_vm_name
  vm_size        = var.admin_vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password
}

module "mysql" {
  source = "../../modules/mysql"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  tags                = var.tags

  mysql_server_name    = var.mysql_server_name
  mysql_admin_username = var.mysql_admin_username
  mysql_admin_password = var.mysql_admin_password
  mysql_database_name  = var.mysql_database_name
  mysql_sku_name       = var.mysql_sku_name
  mysql_storage_gb     = var.mysql_storage_gb
  mysql_version        = var.mysql_version

  subnet_mysql_id = module.networking.subnet_mysql_id
  vnet_prod_id    = module.networking.vnet_prod_id
  vnet_dmz_id     = module.networking.vnet_dmz_id
}

module "webapp" {
  source = "../../modules/webapp"

  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  project_name        = var.project_name
  environment         = var.environment
  tags                = var.tags

  web_app_name         = var.web_app_name
  app_service_sku      = var.app_service_sku
  subnet_webapp_id     = module.networking.subnet_webapp_id
  mysql_fqdn           = module.mysql.mysql_fqdn
  mysql_database_name  = var.mysql_database_name
  mysql_admin_username = var.mysql_admin_username
  mysql_admin_password = var.mysql_admin_password
}