variable "location" {
  default = "Central India"
}

variable "resource_group_name" {
  default = "vexar-prod-rg"
}

variable "environment" {
  default = "production"
}

variable "container_image" {
  default = "vexaracr.azurecr.io/vexar-fleet-ping:latest"
}

variable "postgres_admin_username" {
  default = "vexaradmin"
}

variable "postgres_admin_password" {
  sensitive = true
}

variable "database_name" {
  default = "vexar_fleet"
}