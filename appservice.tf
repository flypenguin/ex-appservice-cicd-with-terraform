terraform {
  ## *I* set all the backend config variables in the file 'backend-config'.
  ## Honestly I forgot why. If you want to store your state in Azure,
  ## uncomment the 'backend' line and add accordingly. if you are using
  ## my makefile add the information in the file 'backend-config'.

  # backend "azurerm" {}
}

provider "azurerm" {
  # https://github.com/hashicorp/terraform/issues/24200
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "flypenguin-appservices0"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "flypenguin-appservices0"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "random_string" "coolapp_rnd" {
  keepers = {
    recreate_trigger = 1
  }
  lower   = true
  special = false
  number  = false
  upper   = false
  length  = 3
}

resource "azurerm_app_service" "coolapp" {
  name                = "flypenguin-coolapp-${random_string.coolapp_rnd.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  app_settings = {
    "my" = "setting"
  }

  site_config {
    scm_type         = "LocalGit" # We configure gitlab to push here ... ?
    linux_fx_version = "PYTHON|3.8"
  }

}

output "coolapp-scm" {
  value = azurerm_app_service.coolapp.source_control
}

output "coolapp-site-credential" {
  value = azurerm_app_service.coolapp.site_credential
}
