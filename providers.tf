provider "azurerm" {
  subscription_id = var. subscription_id  # REDACTED
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
  skip_provider_registration = true
}