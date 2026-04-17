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

variable "vnet_prod_cidr" {
  description = "CIDR de la VNet Producción"
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