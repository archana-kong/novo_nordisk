terraform {
  required_providers {
    konnect = {
      source  = "kong/konnect"
      version = "3.3.0"
    }
  }
}
provider "konnect" {
  # Configuration options
    server_url = var.server_url
    personal_access_token = var.konnect_personal_access_token
}