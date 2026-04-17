variable "subscription_id" {
  description = "ID de la suscripción de Azure"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "project_name" {
  description = "Nombre lógico del proyecto"
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
}

variable "tags" {
  description = "Tags comunes para todos los recursos"
  type        = map(string)
  default     = {}
}

variable "vnet_prod_cidr" {
  description = "CIDR de la VNet de Producción"
  type        = list(string)
}

variable "vnet_ctg_cidr" {
  description = "CIDR de la VNet CTG"
  type        = list(string)
}

variable "vnet_dmz_cidr" {
  description = "CIDR de la VNet DMZ"
  type        = list(string)
}

variable "subnet_prd_cidr" {
  description = "CIDR de la subred PRD"
  type        = list(string)
}

variable "subnet_dev_qas_cidr" {
  description = "CIDR de la subred DEV-QAS"
  type        = list(string)
}

variable "subnet_bastion_cidr" {
  description = "CIDR de la subred AzureBastionSubnet"
  type        = list(string)
}

variable "subnet_lan_cidr" {
  description = "CIDR de la subred LAN"
  type        = list(string)
}

variable "subnet_ctg_cidr" {
  description = "CIDR de la subred CTG"
  type        = list(string)
}

variable "subnet_dmz_cidr" {
  description = "CIDR de la subred DMZ"
  type        = list(string)
}

variable "admin_vm_name" {
  description = "Nombre de la VM de administración"
  type        = string
}

variable "admin_vm_size" {
  description = "Tamaño de la VM de administración"
  type        = string
}

variable "admin_username" {
  description = "Usuario administrador de la VM"
  type        = string
}

variable "admin_password" {
  description = "Contraseña del administrador de la VM"
  type        = string
  sensitive   = true
}

variable "subnet_mysql_cidr" {
  description = "CIDR de la subred MySQL"
  type        = list(string)
}

variable "mysql_server_name" {
  description = "Nombre del servidor MySQL Flexible Server"
  type        = string
}

variable "mysql_admin_username" {
  description = "Usuario administrador de MySQL"
  type        = string
}

variable "mysql_admin_password" {
  description = "Password administrador de MySQL"
  type        = string
  sensitive   = true
}

variable "mysql_database_name" {
  description = "Nombre de la base de datos inicial"
  type        = string
}

variable "mysql_sku_name" {
  description = "SKU de MySQL Flexible Server"
  type        = string
}

variable "mysql_storage_gb" {
  description = "Almacenamiento en GB para MySQL"
  type        = number
}

variable "mysql_version" {
  description = "Versión de MySQL"
  type        = string
}