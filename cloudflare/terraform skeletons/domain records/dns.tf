# Domain
resource "cloudflare_zone" "domain" {
  account = {
    id = var.cloudflare_account
  }
  name = "your-domain.tld"
}

# A Records
resource "cloudflare_dns_record" "www" {
  zone_id = cloudflare_zone.domain.id
  name    = "www"
  content = "203.0.113.123"
  type    = "A"
  ttl     = 1
  proxied = true
}

# MX
resource "cloudflare_dns_record" "mx1" {
  zone_id  = cloudflare_zone.domain.id
  name     = "your-domain.tld"
  content  = "your-mail-server.domain.tld"
  type     = "MX"
  ttl      = 1
  priority = 10
}