locals {
  public_ip_name = "pip-${var.project_name}-bastion-${var.environment}"
  bastion_name   = "bas-${var.project_name}-${var.environment}"
}

resource "azurerm_public_ip" "bastion" {
  name                = local.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "this" {
  name                = local.bastion_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
  tags                = var.tags

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = var.subnet_bastion_id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}