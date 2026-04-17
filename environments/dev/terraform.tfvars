# PROJECT CONFIG
subscription_id     = "c5d9c2b7-44cd-40c2-aea5-b78f1cd6ca83"
location            = "eastus"
resource_group_name = "rg-arq-nube-dev"
project_name        = "arq-nube"
environment         = "dev"

tags = {
  project     = "arq-nube"
  environment = "dev"
  owner       = "shoot"
}

# NETWORK CONFIG
vnet_prod_cidr = ["10.0.0.0/16"]
vnet_ctg_cidr  = ["10.3.0.0/16"]
vnet_dmz_cidr  = ["10.1.0.0/16"]

subnet_prd_cidr     = ["10.0.0.0/24"]
subnet_dev_qas_cidr = ["10.0.1.0/24"]
subnet_bastion_cidr = ["10.0.2.0/26"]
subnet_lan_cidr     = ["10.0.3.0/24"]
subnet_ctg_cidr     = ["10.3.0.0/24"]
subnet_dmz_cidr     = ["10.1.0.0/24"]

# VM CONFIG
admin_vm_name  = "vm-admin-lan-dev"
admin_vm_size  = "Standard_D2s_v3"
admin_username = "azureadmin"
admin_password = "@Lvaro07"

# DATABASE CONFIG
subnet_mysql_cidr    = ["10.0.4.0/24"]
mysql_server_name    = "mysqlarqnubedev01"
mysql_admin_username = "mysqladmin"
mysql_admin_password = "@Lvaro07"
mysql_database_name  = "arqnube"
mysql_sku_name       = "B_Standard_B1ms"
mysql_storage_gb     = 20
mysql_version        = "8.0.21"

# WEB APP CONFIG
subnet_webapp_cidr = ["10.1.1.0/24"]
web_app_name       = "app-arqnube-dev"
app_service_sku    = "B1"