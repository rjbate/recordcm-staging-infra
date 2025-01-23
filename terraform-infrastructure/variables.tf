#
variable "storage_account_state" {
  type    = string
  default = "recordcmrecordtfstatechm"
  #Default to non-prod shared services
}

variable "resource_group_name" {
  type    = string
  default = "record-stg-stg-dev"
}

variable "env_top_level_uami" {
  type    = string
  default = "59361c6d-24b0-4883-9fe4-5a126989031d"
}

variable "record_env" {
  type    = string
  default = "stg-dev"
}

variable "record_env_base" {
  type    = string
  default = "dev"
}

/*
variable "prefix" {
  type    = string
  default = "recordcm-record"
}
*/
variable "azure_devops_project_target" {
  type    = string
  default = "record"
}

/*
variable "azure_devops_organisation_target" {
  type    = string
  default = "recordcm"
}
*/

variable "container_apps_no_ingress" {
  type = map(any)
}

variable "container_apps_ingress" {
  type = map(any)
}

/*
variable "container_apps_no_ingress_peered" {
  type = map(any)
}

variable "container_apps_ingress_peered" {
  type = map(any)
}
*/


variable "common_tags" {
  type = map(string)
  default = {
    "Application"       = "Record"
    "Application Type"  = "Trading Staging"
    "Purpose"           = "Run the Business"
    "CreatedOn"         = "23/01/2025"
    "CreatedBy"         = "DevOps Team - Russell Bate"
    "Approver Name"     = "Paul Sheath"
    "Department"        = "IT"
    "Disaster Recovery" = "Unknown"
    "Cost Centre"       = "CC-example-01"
    "Terraformed"       = "true"
  }
}

locals {
  env_tag = {
    Environment = var.record_env
  }
  #all_tags = merge(local.env_tag, var.common_tags)
}
