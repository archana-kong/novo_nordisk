#Create DCR Provider in Konnect UI or using Konnect API


#Create Auth stratergy
resource "konnect_application_auth_strategy" "azure-oidc-dcr" {
  openid_connect = {
    name = "Azure OIDC"
    dcr_provider_id = "6bd15c90-acac-4599-82ac-e442d1f73a47"
    display_name = "Azure OIDC + DCR Strategy"
    strategy_type = "openid_connect"
    configs = {
      openid_connect = {
        issuer           = "https://sts.windows.net/f177c1d6-50cf-49e0-818a-a0585cbafd8d"
        auth_methods     = ["client_credentials", "bearer", "session"]
        scopes            = ["openid", "email"]
        credential_claim = ["appid"]
      }
    }
  }
}
