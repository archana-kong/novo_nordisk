#Create DCR Provider

resource "konnect_gateway_dcr_provider" "azuredcr" {
  name         = "Azure Entra DCR"
  display_name = "Azure Entra DCR"
  provider_type = "azureAd"
  issuer       = "https://sts.windows.net/YOUR_TENANT_ID"
  dcr_config = {
    initial_client_id     = "ed64b944-07e7-402d-ac6f-943f661b290b"
    initial_client_secret = "0XW8Q~vNaeXADhjhxL357TakbkHWaKfHUOFPya~K"
  }
}

#Create Auth stratergy
resource "konnect_application_auth_strategy" "azure_oidc" {
  name         = "Azure OIDC"
  display_name = "Azure OIDC"
  strategy_type = "openid_connect"
  dcr_provider_id = konnect_gateway_dcr_provider.azuredcr.id
  configs = {
    "openid-connect" = {
      issuer           = "https://sts.windows.net/ f177c1d6-50cf-49e0-818a-a0585cbafd8d"
      credential_claim = ["appid"]
      auth_methods     = ["client_credentials", "bearer", "session"]
      # Add scopes as needed
    }
  }
}