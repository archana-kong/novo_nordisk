#Create DCR Provider in Konnect UI or using Konnect API


#Create Auth stratergy
resource "konnect_application_auth_strategy" "azure_oidc" {
  name           = "Azure OIDC"
  display_name   = "Azure OIDC"
  strategy_type  = "openid_connect"
  dcr_provider_id = "6bd15c90-acac-4599-82ac-e442d1f73a47"
  configs = {
    "openid-connect" = {
      issuer           = "https://sts.windows.net/f177c1d6-50cf-49e0-818a-a0585cbafd8d"
      credential_claim = ["appid"]
      auth_methods     = ["client_credentials", "bearer", "session"]
      scopes         = ["openid", "email"] # Optional, add as needed
    }
  }
}
