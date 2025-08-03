variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_account" {
  description = "Cloudflare account ID"
  type        = string
  sensitive   = true
}