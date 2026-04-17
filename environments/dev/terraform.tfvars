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

vnet_prod_cidr = ["10.0.0.0/16"]
vnet_ctg_cidr  = ["10.3.0.0/16"]
vnet_dmz_cidr  = ["10.1.0.0/16"]

subnet_prd_cidr     = ["10.0.0.0/24"]
subnet_dev_qas_cidr = ["10.0.1.0/24"]
subnet_bastion_cidr = ["10.0.2.0/26"]
subnet_lan_cidr     = ["10.0.3.0/24"]
subnet_ctg_cidr     = ["10.3.0.0/24"]
subnet_dmz_cidr     = ["10.1.0.0/24"]