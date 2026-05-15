# Domain
resource "cloudflare_zone" "domain" {
  account = {
    id = var.cloudflare_account
  }
  name = "your-domain.tld"
}

# A Records
resource "cloudflare_dns_record" "app" {
  zone_id = cloudflare_zone.domain.id
  name    = "app"
  content = "203.0.113.10"
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "mail" {
  zone_id = cloudflare_zone.domain.id
  name    = "mail"
  content = "203.0.113.20"
  type    = "A"
  ttl     = 1
  proxied = false
}

# CNAME Records (DKIM — must not be proxied)
resource "cloudflare_dns_record" "dkim1" {
  zone_id = cloudflare_zone.domain.id
  name    = "dkim1._domainkey"
  content = "dkim1._domainkey.ACCOUNT.dkim-provider.example.com"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}

# MX
resource "cloudflare_dns_record" "mx1" {
  zone_id  = cloudflare_zone.domain.id
  name     = "your-domain.tld"
  content  = "mail.your-domain.tld"
  type     = "MX"
  ttl      = 1
  priority = 10
}

# TXT
resource "cloudflare_dns_record" "spf" {
  zone_id = cloudflare_zone.domain.id
  name    = "your-domain.tld"
  content = "\"v=spf1 mx a ~all\""
  type    = "TXT"
  ttl     = 1
}

resource "cloudflare_dns_record" "dmarc" {
  zone_id = cloudflare_zone.domain.id
  name    = "_dmarc"
  content = "\"v=DMARC1; p=none;\""
  type    = "TXT"
  ttl     = 1
}
