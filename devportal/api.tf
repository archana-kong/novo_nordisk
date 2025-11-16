
#Create an API
resource "konnect_api" "my_api" {
  description = "My NN API Description"
  name        = "NNAPI"
  slug        = "nn-api-v1-implementation"
  version     = "v1"
  attributes = jsonencode({
    environment = ["staging"],
  })
}

#Create and associate a spec and version
resource "konnect_api_version" "my_apiversion" {
  api_id = konnect_api.my_api.id
  spec = {
    content = "{\"openapi\":\"3.0.3\",\"info\":{\"title\":\"Example API\",\"version\":\"1.0.0\"},\"paths\":{\"/example\":{\"get\":{\"summary\":\"Example endpoint\",\"responses\":{\"200\":{\"description\":\"Successful response\"}}}}}}"
  }
  version = "1.0.0"
}

#Create and associate an API document
resource "konnect_api_document" "my_apidocument" {
  api_id = konnect_api.my_api.id
  content = "# content goes here, API Document Header"
  slug    = "nn-api-document"
  status  = "published"
  title   = "API Document Title"
}

#Associate the API with a Gateway Service
resource "konnect_api_implementation" "my_apiimplementation" {
  api_id = konnect_api.my_api.id
  service_reference = {
    service = {
      control_plane_id = "49fad1c5-753d-4265-9d46-76aa92d3175b"
      id               = "3b3598bb-eebe-4d78-9fc4-dba980709e07"
    }
  }
}



#Publish the API to Dev Portal

resource "konnect_api_publication" "my_apipublication" {
  api_id                     = konnect_api.my_api.id
  auto_approve_registrations = false
  portal_id                  = konnect_portal.my_portal.id
  visibility                 = "private"
   auth_strategy_ids = [
    konnect_application_auth_strategy.azure-oidc-dcr.id
  ]
}
