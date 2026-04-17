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

variable "subnet_id" {
  description = "ID de la subred donde irá la VM"
  type        = string
}

variable "vm_name" {
  description = "Nombre de la VM"
  type        = string
}

variable "vm_size" {
  description = "Tamaño de la VM"
  type        = string
  default     = "Standard_B1ms"
}

variable "admin_username" {
  description = "Usuario administrador"
  type        = string
}

variable "admin_password" {
  description = "Contraseña del administrador"
  type        = string
  sensitive   = true
}