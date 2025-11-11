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
    # system_account_access_token = var.system_account_access_token
    personal_access_token = var.konnect_personal_access_token
}

resource "konnect_gateway_control_plane" "kongair_internal_cp" {
  auth_type     = "pki_client_certs"
  cloud_gateway = false
  cluster_type  = "CLUSTER_TYPE_CONTROL_PLANE"
  description   = "CP for KongAir Internal API Configurations"
  labels = {
    env = var.environment
    team = "kong-air-internal"
    generated_by =  "terraform"
  }
  name = "KongAir_Internal1"
}
resource "konnect_gateway_control_plane" "kongair_external_cp" {
  name = "KongAir_External"
  auth_type     = "pki_client_certs"
  cloud_gateway = false
  cluster_type  = "CLUSTER_TYPE_CONTROL_PLANE"
  description   = "CP for KongAir External API Configurations"
  labels = {
    env = var.environment
    team = "kong-air-external"
    generated_by =  "terraform"
  }
}
resource "konnect_gateway_control_plane" "kongair_global_cp" {
  name = "KongAir_Global"
  auth_type     = "pki_client_certs"
  cloud_gateway = false
  cluster_type  = "CLUSTER_TYPE_CONTROL_PLANE"
  description   = "CP for KongAir Global API Configurations"
  labels = {
    env = var.environment
    team = "platform"
    generated_by =  "terraform"
  }
}
resource "konnect_gateway_control_plane" "kongair_internal_cp_group" {
  name = "KongAir_Internal_CP_Group"
  auth_type     = "pki_client_certs"
  cloud_gateway = false
  cluster_type  = "CLUSTER_TYPE_CONTROL_PLANE_GROUP"
  description   = "CP group for KongAir Internal Gateways"
  labels = {
    env = var.environment
    generated_by =  "terraform"
  }
}
resource "konnect_gateway_control_plane" "kongair_external_cp_group" {
  name = "KongAir_External_CP_Group"
  auth_type     = "pki_client_certs"
  cloud_gateway = false
  cluster_type  = "CLUSTER_TYPE_CONTROL_PLANE_GROUP"
  description   = "CP group for KongAir External Gateways"
  labels = {
    env = var.environment
    generated_by =  "terraform"
  }
}
resource "konnect_gateway_control_plane_membership" "kongair_internal_cp_group_membership" {
  id = konnect_gateway_control_plane.kongair_internal_cp_group.id
  members = [
    {
      id = konnect_gateway_control_plane.kongair_internal_cp.id
    },
    {
      id = konnect_gateway_control_plane.kongair_global_cp.id
    }
  ]
}
resource "konnect_gateway_control_plane_membership" "kongair_external_cp_group_membership" {
  id = konnect_gateway_control_plane.kongair_external_cp_group.id
  members = [
    {
      id = konnect_gateway_control_plane.kongair_external_cp.id
    },
    {
      id = konnect_gateway_control_plane.kongair_global_cp.id
    }
  ]
}

# Internal Developer Team
# The internal developers team is responsible for managing the internal control plane configuration

resource "konnect_team" "kong_air_internal_devs" {
  description = "Allow managing the internal control plane configuration."
  name        = "Kong Air Internal Developers"
}
resource "konnect_team_role" "kong_air_internal_cp_admin" {
  entity_id        = konnect_gateway_control_plane.kongair_internal_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Admin"
  team_id          = konnect_team.kong_air_internal_devs.id
}
# Internal Viewers Team
# The internal viewers team is responsible for monitoring the internal control plane configuration and will have read only access to the Internal Control Plane.

resource "konnect_team" "kong_air_internal_viewers" {
  description = "Allow read-only access to all entities in the internal control plane"
  name        = "Kong Air Internal Viewers"
}

resource "konnect_team_role" "kong_air_internal_cp_viewer" {
  entity_id        = konnect_gateway_control_plane.kongair_internal_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Viewer"
  team_id          = konnect_team.kong_air_internal_viewers.id
}
# External Developers Team
# The external developers team is responsible for managing the external control plane configuration

resource "konnect_team" "kong_air_external_devs" {
  description = "Allow managing the external control plane configuration."
  name        = "Kong Air External Developers"
}

resource "konnect_team_role" "kong_air_external_cp_admin" {
  entity_id        = konnect_gateway_control_plane.kongair_external_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Admin"
  team_id          = konnect_team.kong_air_external_devs.id
}
# External Viewers Team
# The external viewers team is responsible for monitoring the internal control plane configuration

resource "konnect_team" "kong_air_external_viewers" {
  description = "Allow read-only access to all entities in the external control plane"
  name        = "Kong Air External Viewers"
}

resource "konnect_team_role" "kong_air_external_cp_viewer" {
  entity_id        = konnect_gateway_control_plane.kongair_external_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Viewer"
  team_id          = konnect_team.kong_air_external_viewers.id
}
# Platform Admins Team
# The platform admins team is responsible for managing all entities in the global,
# internal and external control planes.

resource "konnect_team" "platform_admins" {
  description = "Allow managing entities in the global, internal and external control planes"
  name        = "Platform Admins"
}

resource "konnect_team_role" "platform_admins_global_cp_admin" {
  entity_id        = konnect_gateway_control_plane.kongair_global_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Admin"
  team_id          = konnect_team.platform_admins.id
}

resource "konnect_team_role" "platform_admins_internal_cp_admin" {
  entity_id        = konnect_gateway_control_plane.kongair_internal_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Admin"
  team_id          = konnect_team.platform_admins.id
}

resource "konnect_team_role" "platform_admins_external_cp_admin" {
  entity_id        = konnect_gateway_control_plane.kongair_external_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Admin"
  team_id          = konnect_team.platform_admins.id
}
# Platform Viewers Team
# The platform viewers team is responsible for monitoring all entities in the global,
# internal and external control planes.

resource "konnect_team" "platform_viewers" {
  description = "Allow read-only access to all entities in the global, internal and external control planes"
  name        = "Platform Viewers"
}

resource "konnect_team_role" "platform_viewers_global_cp_viewer" {
  entity_id        = konnect_gateway_control_plane.kongair_global_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Viewer"
  team_id          = konnect_team.platform_viewers.id
}

resource "konnect_team_role" "platform_viewers_internal_cp_viewer" {
  entity_id        = konnect_gateway_control_plane.kongair_internal_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Viewer"
  team_id          = konnect_team.platform_viewers.id
}

resource "konnect_team_role" "platform_viewers_external_cp_viewer" {
  entity_id        = konnect_gateway_control_plane.kongair_external_cp.id
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Viewer"
  team_id          = konnect_team.platform_viewers.id
}

#Create a Control Plane vault to store the sytem account
resource "konnect_gateway_vault" "github_vault" {
  name              = "env"
  prefix            = "my-env-vault"
  config            = jsonencode({
    prefix = "MY_SECRET_"
  })
  control_plane_id  = konnect_gateway_control_plane.kongair_global_cp.id
  tags              = []
}


# Create a system account
resource "konnect_system_account" "global_cp_viewer" {
  name            = "global_cp_viewer"
  description     = "System account for managing the global control plane"
  konnect_managed = false

}

# Create a role for the system account
resource "konnect_system_account_role" "global_cp_viewer_role" {
  account_id       = konnect_system_account.global_cp_viewer.id
  entity_id        = "*"
  entity_region    = "us"
  entity_type_name = "Control Planes"
  role_name        = "Viewer"
}

# Create an access token for the system account
resource "konnect_system_account_access_token" "global_cp_viewer_token" {

  name       = "global-cp-viewer-token"
  expires_at = "2025-12-31T23:59:59Z"
  account_id = konnect_system_account.global_cp_viewer.id

}

# Output token for external use (e.g., GitHub Actions)
output "global_cp_viewer_token_value" {
  value       = konnect_system_account_access_token.global_cp_viewer_token.token
  description = "Access token for global_cp_viewer system account"
  sensitive   = true
}

# Upload Server certificate
resource "konnect_gateway_certificate" "my_certificate" {
  cert             = file("./tls.crt")
  key              = file("./tls.key")
  control_plane_id = konnect_gateway_control_plane.kongair_global_cp.id
}

# Upload CA cert to validate clients
resource "konnect_gateway_ca_certificate" "my_gatewaycacertificate" {
  cert             = file("./ca-cert.pem")
  control_plane_id = konnect_gateway_control_plane.kongair_global_cp.id 
}

# Upload Dataplane certificate
resource "konnect_gateway_data_plane_client_certificate" "my_gatewaydataplaneclientcertificate" {
  cert             = file("./ca-cert.pem")
  control_plane_id = konnect_gateway_control_plane.kongair_global_cp.id 
}
