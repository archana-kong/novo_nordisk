# Make sure you have Gateway Service entities added in the Control Plane before creating Dev portal and associated API's

resource "konnect_portal" "my_portal" {
  authentication_enabled               = true
  auto_approve_applications            = false
  auto_approve_developers              = true
  default_api_visibility               = "private"
  default_page_visibility              = "public"
  description                          = "DevPortal Automated"
  display_name                         = "NN DevPortal Automated"
  force_destroy                        = "false"
  name         = "NN-devportal-auto"
  rbac_enabled = true
}

resource "konnect_portal_snippet" "my_portal_snippet" {
  content     = "# Welcome to My Snippet"
  description = "A custom snippet about developer portals"
  name        = "my-snippet"
  title       = "My NN Snippet"
  portal_id   = konnect_portal.my_portal.id
  status      = "published"
  visibility  = "public"
}

resource "konnect_portal_page" "my_portalpage" {
  portal_id   = konnect_portal.my_portal.id
  title       = "Deployed API's in NN"
  slug        = "/apis"
  description = "A custom page about developer portals"
  visibility  = "public"
  status      = "published"

  content = <<-MD
  # Welcome to NN Dev Portal

  Explore the available APIs below:

  ::apis-list
  ---
  persist-page-number: true
  cta-text: "View APIs"
  ---
  MD
}

resource "konnect_portal_logo" "my_portal_logo" {
  data      = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg=="
  portal_id = konnect_portal.my_portal.id
}

resource "konnect_portal_favicon" "my_portal_favicon" {
  data      = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGMAAQAABQABDQottAAAAABJRU5ErkJggg=="
  portal_id = konnect_portal.my_portal.id
}

#resource "konnect_portal_custom_domain" "my_portal_custom_domain" {
  #enabled   = false
  #hostname  = "my.custom.domain"
  #portal_id = konnect_portal.my_portal.id
  #ssl = {
    #domain_verification_method = "http"
  #}
#}

  # Create a new team in the Dev Portal
resource "konnect_portal_team" "my_portal_platformteam" {
    portal_id = konnect_portal.my_portal.id
    name = "NN-DevPortal-platform-team"
    description = "Dev Portal Platform Team to manage the NN Dev Portal"
}

resource "konnect_portal_team" "my_portal_devteam" {
    portal_id = konnect_portal.my_portal.id
    name = "NN-DevPortal-dev-team"
    description = "Dev Portal dev Team to access the NN Dev Portal API's"
}
