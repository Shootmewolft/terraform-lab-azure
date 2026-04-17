locals {
  vnet_prod_name = "vnet-${var.project_name}-prod-${var.environment}"
  vnet_ctg_name  = "vnet-${var.project_name}-ctg-${var.environment}"
  vnet_dmz_name  = "vnet-${var.project_name}-dmz-${var.environment}"

  subnet_prd_name     = "snet-prd"
  subnet_dev_qas_name = "snet-dev-qas"
  subnet_bastion_name = "AzureBastionSubnet"
  subnet_lan_name     = "snet-lan"
  subnet_mysql_name   = "snet-mysql"
  subnet_ctg_name     = "snet-ctg"
  subnet_dmz_name     = "snet-dmz"
}

resource "azurerm_virtual_network" "prod" {
  name                = local.vnet_prod_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_prod_cidr
  tags                = var.tags
}

resource "azurerm_virtual_network" "ctg" {
  name                = local.vnet_ctg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_ctg_cidr
  tags                = var.tags
}

resource "azurerm_virtual_network" "dmz" {
  name                = local.vnet_dmz_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_dmz_cidr
  tags                = var.tags
}

resource "azurerm_subnet" "prd" {
  name                 = local.subnet_prd_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = var.subnet_prd_cidr
}

resource "azurerm_subnet" "dev_qas" {
  name                 = local.subnet_dev_qas_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = var.subnet_dev_qas_cidr
}

resource "azurerm_subnet" "bastion" {
  name                 = local.subnet_bastion_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = var.subnet_bastion_cidr
}

resource "azurerm_subnet" "lan" {
  name                 = local.subnet_lan_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = var.subnet_lan_cidr
}

resource "azurerm_subnet" "mysql" {
  name                 = local.subnet_mysql_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.prod.name
  address_prefixes     = var.subnet_mysql_cidr

  delegation {
    name = "mysql-flexible-delegation"

    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_subnet" "ctg" {
  name                 = local.subnet_ctg_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ctg.name
  address_prefixes     = var.subnet_ctg_cidr
}

resource "azurerm_subnet" "dmz" {
  name                 = local.subnet_dmz_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.dmz.name
  address_prefixes     = var.subnet_dmz_cidr
}

resource "azurerm_virtual_network_peering" "prod_to_ctg" {
  name                         = "peer-prod-to-ctg"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.prod.name
  remote_virtual_network_id    = azurerm_virtual_network.ctg.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "ctg_to_prod" {
  name                         = "peer-ctg-to-prod"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.ctg.name
  remote_virtual_network_id    = azurerm_virtual_network.prod.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "prod_to_dmz" {
  name                         = "peer-prod-to-dmz"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.prod.name
  remote_virtual_network_id    = azurerm_virtual_network.dmz.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "dmz_to_prod" {
  name                         = "peer-dmz-to-prod"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.dmz.name
  remote_virtual_network_id    = azurerm_virtual_network.prod.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "ctg_to_dmz" {
  name                         = "peer-ctg-to-dmz"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.ctg.name
  remote_virtual_network_id    = azurerm_virtual_network.dmz.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "dmz_to_ctg" {
  name                         = "peer-dmz-to-ctg"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.dmz.name
  remote_virtual_network_id    = azurerm_virtual_network.ctg.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}