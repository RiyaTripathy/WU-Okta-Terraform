variable "org_name" {}
variable "api_token" {}
variable "base_url" {}

provider "okta" {
    org_name = var.org_name
    base_url = var.base_url
    api_token = var.api_token
}
resource "okta_group" "FBImember_group" {
  name        = "FBI Member"
  description = "FBI Member with role code EXT1"
}

resource "okta_group" "FBImemberadmin_group" {
  name        = "FBI Member Admin"
  description = "FBI Member Admin with role code EXT2"
}
data "okta_auth_server" "authserver_test" {
  name = "default"
}
resource "okta_auth_server_claim" "div_claim" {
  auth_server_id = data.okta_auth_server.authserver_test.id
  name           = "division_code"
  value_type     = "EXPRESSION"
  value          = "user.divisions"
  claim_type     = "RESOURCE"
}
resource "okta_auth_server_claim" "role_claim" {
  auth_server_id = data.okta_auth_server.authserver_test.id
  name           = "role"
  value_type     = "EXPRESSION"
  value          = "user.role_code"
  claim_type     = "RESOURCE"
}
resource "okta_auth_server_claim" "company_claim" {
  auth_server_id = data.okta_auth_server.authserver_test.id
  name           = "company_code"
  value_type     = "EXPRESSION"
  value          = "user.company"
  claim_type     = "RESOURCE"
}
resource "okta_trusted_origin" "trusted_test" {
  name   = "FBI Benchmark URL"
  origin = "https://benchmark.performanceroundtables.com/"
  scopes = ["CORS","REDIRECT"]
}