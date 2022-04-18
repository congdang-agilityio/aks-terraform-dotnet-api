variable appId {}
variable password {}
variable ssh_public_key {}
variable "resource_group_name" {
  description = "Azure Resource Group name"
}
variable "location" {
  description = "Azure Resource Group location"
}
variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}