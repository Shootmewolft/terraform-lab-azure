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

variable "subnet_prd_id" {
  description = "ID de la subred PRD"
  type        = string
}

variable "subnet_dev_qas_id" {
  description = "ID de la subred DEV-QAS"
  type        = string
}

variable "subnet_ctg_id" {
  description = "ID de la subred CTG"
  type        = string
}

variable "subnet_dmz_id" {
  description = "ID de la subred DMZ"
  type        = string
}

variable "subnet_lan_id" {
  description = "ID de la subred LAN"
  type        = string
}