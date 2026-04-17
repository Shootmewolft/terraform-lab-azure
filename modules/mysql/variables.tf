variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "tags" {
  description = "Tags comunes"
  type        = map(string)
  default     = {}
}

variable "mysql_server_name" {
  description = "Nombre del servidor MySQL Flexible Server"
  type        = string
}

variable "mysql_admin_username" {
  description = "Usuario administrador"
  type        = string
}

variable "mysql_admin_password" {
  description = "Password administrador"
  type        = string
  sensitive   = true
}

variable "mysql_database_name" {
  description = "Nombre de la base de datos"
  type        = string
}

variable "mysql_sku_name" {
  description = "SKU de MySQL Flexible Server"
  type        = string
}

variable "mysql_storage_gb" {
  description = "Storage en GB"
  type        = number
}

variable "mysql_version" {
  description = "Versión de MySQL"
  type        = string
}

variable "subnet_mysql_id" {
  description = "ID de la subnet delegada para MySQL"
  type        = string
}

variable "vnet_prod_id" {
  description = "ID de la VNet de Producción"
  type        = string
}

variable "vnet_dmz_id" {
  description = "ID de la VNet DMZ"
  type        = string
}