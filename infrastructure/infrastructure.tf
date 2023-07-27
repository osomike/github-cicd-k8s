###########################################################
### Default configuration block when working with Azure ###
###########################################################
terraform {
  # Provide configuration details for Terraform
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.50"
    }

  }
  # This block allows us to save the terraform.tfstate file on the cloud, so a team of developers can use the terraform
  # configuration to update the infrastructure.
  # Link: https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli
  # Note.- Before using this block, is important that the resource group, storage account and container ARE DEPLOYED.
  backend "azurerm" {
    resource_group_name  = "dip-prd-master-rg"
    storage_account_name = "dipprdmasterst"
    container_name       = "dip-prd-asdlgen2-fs-config"
    key                  = "k8s-training-rg/terraform.tfstate"
    
  }

}

# provide configuration details for the Azure terraform provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

###########################################################
##############  Create Service Principal ##################
###########################################################
#https://stackoverflow.com/questions/53991906/how-can-i-use-terraform-to-create-a-service-principal-and-use-that-principal-in

data "azuread_client_config" "current" {}

###########################################################
###################  Resource Group #######################
###########################################################
resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.default_prefix}-${var.environment}-rg"
  tags = {
    owner       = var.owner
    environment = var.environment
  }
}

###########################################################
###################  Storage Account ######################
###########################################################
# https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy#locally-redundant-storage
resource "azurerm_storage_account" "storageaccount" {
  name = "${var.default_prefix}${var.environment}${var.random_id}st"
                # Between 3 to 24 characters and
                # UNIQUE within Azure
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

  tags = {
    owner       = var.owner
    environment = var.environment
  }
}


###########################################################
########  Azure Storage Data Lake Gen2 Filesystem #########
###########################################################
resource "azurerm_storage_data_lake_gen2_filesystem" "myasdlgen2replica1" {
  name               = "${var.default_prefix}-${var.environment}-adlsgen2"
  storage_account_id = azurerm_storage_account.storageaccount.id

  properties = {
    hello = "aGVsbG8="
  }
}


