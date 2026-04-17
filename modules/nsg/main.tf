locals {
  nsg_prd_name     = "nsg-${var.project_name}-prd-${var.environment}"
  nsg_dev_qas_name = "nsg-${var.project_name}-dev-qas-${var.environment}"
  nsg_ctg_name     = "nsg-${var.project_name}-ctg-${var.environment}"
  nsg_dmz_name     = "nsg-${var.project_name}-dmz-${var.environment}"
  nsg_lan_name     = "nsg-${var.project_name}-lan-${var.environment}"
  nsg_mysql_name   = "nsg-${var.project_name}-mysql-${var.environment}"
  nsg_webapp_name  = "nsg-${var.project_name}-webapp-${var.environment}"
}

resource "azurerm_network_security_group" "prd" {
  name                = local.nsg_prd_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "dev_qas" {
  name                = local.nsg_dev_qas_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "ctg" {
  name                = local.nsg_ctg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "dmz" {
  name                = local.nsg_dmz_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_group" "lan" {
  name                = local.nsg_lan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# -------------------------
# NSG PRD
# -------------------------

resource "azurerm_network_security_rule" "prd_allow_lan_rdp" {
  name                        = "allow-lan-rdp-to-prd"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "10.0.3.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.prd.name
}

resource "azurerm_network_security_rule" "prd_allow_lan_ssh" {
  name                        = "allow-lan-ssh-to-prd"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.3.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.prd.name
}

resource "azurerm_network_security_rule" "prd_allow_dev_qas_to_app" {
  name                        = "allow-dev-qas-to-prd-app"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["3200", "443"]
  source_address_prefix       = "10.0.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.prd.name
}

resource "azurerm_network_security_rule" "prd_deny_ctg" {
  name                        = "deny-ctg-to-prd"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.3.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.prd.name
}

resource "azurerm_network_security_rule" "prd_deny_dmz" {
  name                        = "deny-dmz-to-prd"
  priority                    = 140
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.1.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.prd.name
}

# -------------------------
# NSG DEV-QAS
# -------------------------

resource "azurerm_network_security_rule" "dev_qas_allow_lan_rdp" {
  name                        = "allow-lan-rdp-to-dev-qas"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "10.0.3.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.dev_qas.name
}

resource "azurerm_network_security_rule" "dev_qas_allow_lan_ssh" {
  name                        = "allow-lan-ssh-to-dev-qas"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.3.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.dev_qas.name
}

resource "azurerm_network_security_rule" "dev_qas_deny_dmz" {
  name                        = "deny-dmz-to-dev-qas"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.1.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.dev_qas.name
}

resource "azurerm_network_security_rule" "dev_qas_deny_internet" {
  name                        = "deny-internet-to-dev-qas"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.dev_qas.name
}

# -------------------------
# NSG CTG
# -------------------------

resource "azurerm_network_security_rule" "ctg_allow_lan_rdp" {
  name                        = "allow-lan-rdp-to-ctg"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "10.0.3.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.ctg.name
}

resource "azurerm_network_security_rule" "ctg_allow_lan_ssh" {
  name                        = "allow-lan-ssh-to-ctg"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.3.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.ctg.name
}

resource "azurerm_network_security_rule" "ctg_allow_ad_to_prd_dns" {
  name                        = "allow-ctg-to-prd-dns"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.ctg.name
}

resource "azurerm_network_security_rule" "ctg_allow_ad_to_prd_ldap" {
  name                        = "allow-ctg-to-prd-ldap"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.ctg.name
}

resource "azurerm_network_security_rule" "ctg_deny_prd" {
  name                        = "deny-ctg-to-prd"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.ctg.name
}

resource "azurerm_network_security_rule" "ctg_deny_dmz" {
  name                        = "deny-ctg-to-dmz"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.1.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.ctg.name
}

# -------------------------
# NSG DMZ
# -------------------------

resource "azurerm_network_security_rule" "dmz_allow_http" {
  name                        = "allow-internet-http-to-dmz"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.dmz.name
}

resource "azurerm_network_security_rule" "dmz_allow_https" {
  name                        = "allow-internet-https-to-dmz"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.dmz.name
}

resource "azurerm_network_security_rule" "dmz_allow_prd_internal" {
  name                        = "allow-prd-to-dmz-internal"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["22", "445"]
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.dmz.name
}

resource "azurerm_network_security_rule" "dmz_deny_prd" {
  name                        = "deny-dmz-to-prd"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.dmz.name
}

resource "azurerm_network_security_rule" "dmz_deny_ctg" {
  name                        = "deny-dmz-to-ctg"
  priority                    = 140
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.3.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.dmz.name
}

# -------------------------
# NSG LAN
# -------------------------

resource "azurerm_network_security_rule" "lan_allow_ad_ldap" {
  name                        = "allow-lan-to-ad-ldap"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "389"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.lan.name
}

resource "azurerm_network_security_rule" "lan_allow_ad_kerberos" {
  name                        = "allow-lan-to-ad-kerberos"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "88"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.lan.name
}

resource "azurerm_network_security_rule" "lan_allow_ad_smb" {
  name                        = "allow-lan-to-ad-smb"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "445"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.lan.name
}

resource "azurerm_network_security_rule" "lan_allow_ad_dns" {
  name                        = "allow-lan-to-ad-dns"
  priority                    = 130
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.lan.name
}

resource "azurerm_network_security_rule" "lan_allow_http_dmz" {
  name                        = "allow-lan-to-dmz-http"
  priority                    = 140
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "10.1.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.lan.name
}

resource "azurerm_network_security_rule" "lan_deny_dmz_other" {
  name                        = "deny-lan-to-dmz-other"
  priority                    = 150
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.1.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.lan.name
}

# -------------------------
# NSG MySQL
# -------------------------

resource "azurerm_network_security_group" "mysql" {
  name                = local.nsg_mysql_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "mysql_allow_prd" {
  name                        = "allow-prd-to-mysql"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "10.0.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.mysql.name
}

resource "azurerm_network_security_rule" "mysql_allow_lan" {
  name                        = "allow-lan-to-mysql"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "10.0.3.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.mysql.name
}

resource "azurerm_network_security_rule" "mysql_allow_webapp" {
  name                        = "allow-webapp-to-mysql"
  priority                    = 115
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "10.1.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.mysql.name
}

resource "azurerm_network_security_rule" "mysql_deny_ctg" {
  name                        = "deny-ctg-to-mysql"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.3.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.mysql.name
}

resource "azurerm_network_security_rule" "mysql_deny_dmz" {
  name                        = "deny-dmz-to-mysql"
  priority                    = 130
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.1.0.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.mysql.name
}

# -------------------------
# NSG Web App
# -------------------------

resource "azurerm_network_security_group" "webapp" {
  name                = local.nsg_webapp_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "webapp_allow_mysql" {
  name                        = "allow-webapp-to-mysql"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.4.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.webapp.name
}

resource "azurerm_network_security_rule" "webapp_deny_ctg" {
  name                        = "deny-webapp-to-ctg"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.3.0.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.webapp.name
}

resource "azurerm_network_security_rule" "webapp_deny_lan" {
  name                        = "deny-webapp-to-lan"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "10.0.3.0/24"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.webapp.name
}

# -------------------------
# Associations
# -------------------------

resource "azurerm_subnet_network_security_group_association" "prd" {
  subnet_id                 = var.subnet_prd_id
  network_security_group_id = azurerm_network_security_group.prd.id
}

resource "azurerm_subnet_network_security_group_association" "dev_qas" {
  subnet_id                 = var.subnet_dev_qas_id
  network_security_group_id = azurerm_network_security_group.dev_qas.id
}

resource "azurerm_subnet_network_security_group_association" "ctg" {
  subnet_id                 = var.subnet_ctg_id
  network_security_group_id = azurerm_network_security_group.ctg.id
}

resource "azurerm_subnet_network_security_group_association" "dmz" {
  subnet_id                 = var.subnet_dmz_id
  network_security_group_id = azurerm_network_security_group.dmz.id
}

resource "azurerm_subnet_network_security_group_association" "lan" {
  subnet_id                 = var.subnet_lan_id
  network_security_group_id = azurerm_network_security_group.lan.id
}

resource "azurerm_subnet_network_security_group_association" "mysql" {
  subnet_id                 = var.subnet_mysql_id
  network_security_group_id = azurerm_network_security_group.mysql.id
}

resource "azurerm_subnet_network_security_group_association" "webapp" {
  subnet_id                 = var.subnet_webapp_id
  network_security_group_id = azurerm_network_security_group.webapp.id
}