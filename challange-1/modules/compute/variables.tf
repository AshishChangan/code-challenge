variable "webapp_vmname" {
  description = "The name of the virtual machine used to deploy the vms."
  #type        = list
  #default     = "test"
}
variable "app_vmname" {
  description = "The name of the virtual machine used to deploy the vms."
  #type        = list
  #default     = "test"
}
variable "webapp_instances" {
  description = "number of instances you want deploy from the template."
  default     = 1
}
variable "app_instances" {
  description = "number of instances you want deploy from the template."
  default     = 1
}
variable "webapp_machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  type        = string
  default     = "n1-standard-1"
}
variable "app_machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  type        = string
  default     = "n1-standard-1"
}
variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = null
}
variable "zone" {
  type        = string
  description = "Zone where the instances should be created. If not specified, instances will be spread across available zones in the region."
  default     = null
}
variable "source_image" {
  description = "Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = ""
}

variable "source_image_family" {
  description = "Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public CentOS image."
  type        = string
  default     = "centos-7"
}

variable "source_image_project" {
  description = "Project where the source image comes from. The default project contains CentOS images."
  type        = string
  default     = "centos-cloud"
}
variable "network_name" {
  description = "Name of the network this set of firewall rules applies to."
  type        = string
}
variable "network_name" {
  description = "Name of the network this set of firewall rules applies to."
  type        = string
}