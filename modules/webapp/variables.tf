variable "resource_group_name" {
  description = "Nombre del Resource Group"
  type        = string
}

variable "location" {
  description = "Región de Azure"
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
  description = "Tags comunes"
  type        = map(string)
  default     = {}
}

variable "web_app_name" {
  description = "Nombre de la Web App (debe ser globalmente único)"
  type        = string
}

variable "app_service_sku" {
  description = "SKU del App Service Plan"
  type        = string
  default     = "B1"
}

variable "subnet_webapp_id" {
  description = "ID de la subred para VNet Integration"
  type        = string
}

variable "mysql_fqdn" {
  description = "FQDN del servidor MySQL Flexible Server"
  type        = string
}

variable "mysql_database_name" {
  description = "Nombre de la base de datos MySQL"
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
