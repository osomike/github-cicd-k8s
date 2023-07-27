variable "azure_subs_id" {
  type        = string
  default     = "ef0661c5-0e9a-4467-ba85-e57a8816570d"
  description = "Subscription ID"
}

variable "default_prefix" {
  type        = string
  default     = "k8s" # Up to 10 alphanumerical characters
  description = "Prefix used to name the resources and applications"
}

variable "random_id" {
  type        = string
  default     = "001" # up to 6 alphanumerical characters. Preferably starts and ends with a number.
  description = "Random alphanumerical value to generate unique names for different components within Azure"
}

variable "environment" {
  type        = string
  default     = "training" # up to 6 alphanumerical characters. Preferably starts and ends with a number.
  description = "Random alphanumerical value to generate unique names for different components within Azure"
}

variable "owner" {
  type        = string
  default     = "Oscar Mike"
  description = "Name of the owner"
}

variable "location" {
  type        = string
  default     = "West Europe"
  description = "Location where the resources will be deployed"
}

variable "default_cluster" {
  type = map(any)
  default = {
    spark_version             = "11.3.x-scala2.12"
    node_type_id              = "Standard_DS3_v2"
    "max_workers"             = 4
    "min_workers"             = 2
    "autotermination_minutes" = 20
  }
  description = "Parameters for creating the default cluster for databricks"
}
