resource "cloudflare_zero_trust_access_application" "admin" {
  account_id       = var.cloudflare_account
  name             = "Admin"
  domain           = "app.your-domain.tld/admin*"
  type             = "self_hosted"
  session_duration = "24h"

  policies = [{
    name       = "Allow authorised email domain"
    decision   = "allow"
    precedence = 1

    include = [
      # Add additional email_domain blocks to grant access to more domains
      { email_domain = { domain = "your-domain.tld" } },
    ]
  }]
}

resource "cloudflare_zero_trust_access_application" "login" {
  account_id       = var.cloudflare_account
  name             = "Login"
  domain           = "app.your-domain.tld/login"
  type             = "self_hosted"
  session_duration = "24h"

  policies = [{
    name       = "Allow authorised email domain"
    decision   = "allow"
    precedence = 1

    include = [
      { email_domain = { domain = "your-domain.tld" } },
    ]
  }]
}
