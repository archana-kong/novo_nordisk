#Create DCR Provider in Konnect UI or using Konnect API


#Create Auth stratergy
resource "konnect_application_auth_strategy" "azure-oidc-dcr" {
  name           = "Azure OIDC"
  display_name = "Azure OIDC"
  active = true
  openid_connect = {
    active = true
    dcr_provider_id = "6bd15c90-acac-4599-82ac-e442d1f73a47"
    display_name = "Azure OIDC + DCR Strategy"
    configs = {
      openid_connect = {
        issuer           = "https://sts.windows.net/f177c1d6-50cf-49e0-818a-a0585cbafd8d"
        auth_methods     = ["client_credentials", "bearer", "session"]
        scopes            = ["openid", "email"]
        credential_claim = ["appid"]
      }
    }
    dcr_provider = {
      id           = "6bd15c90-acac-4599-82ac-e442d1f73a47"
      name         = "azure-dcr-provider"
      display_name = "Azure Dynamic Client Registration"
      provider_type = "azureAd"
    }
   
  }
}
