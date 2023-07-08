
# subscription_id
variable "subscription_id" {
  default="12345678"
}


#Location of all lab stuff

variable "resource_group_location" {
  type        = string
  default     = "northeurope"
  description = "Location of the resource group."
}


variable "default-admin-username" {
  default="admin123"
}

variable "default-admin-pass" {
  default="pass123"
}


variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}