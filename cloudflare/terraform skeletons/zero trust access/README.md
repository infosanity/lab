# Cloudflare Zero Trust Access

Skeleton for managing a Cloudflare zone with Zero Trust Access policies protecting sensitive paths (e.g. admin, login) via OTP email authentication.

## Files

| File | Purpose |
|---|---|
| `provider.tf` | Cloudflare provider (v5) |
| `variables.tf` | Input variables — API token and account ID |
| `dns.tf` | Zone and DNS records (A, CNAME, MX, TXT) |
| `access.tf` | Zero Trust Access applications with email domain policies |
| `terraform.tfvars-dist` | Variable value template — copy to `terraform.tfvars` |

## Prerequisites

Cloudflare API token with:
- Zone / Zone: Edit
- Zone / DNS: Edit
- Account / Access: Apps and Policies: Edit

## Usage

```shell
cp terraform.tfvars-dist terraform.tfvars
# Fill in cloudflare_account and cloudflare_api_token

terraform init
terraform plan
terraform apply
```

## Notes

**Provider v5 inline policies** — Access policies are defined inline within `cloudflare_zero_trust_access_application`. The separate `cloudflare_access_policy` resource (v4 pattern) no longer exists in v5.

**Zone activation order** — Access applications will fail on `apply` if the zone is not yet active in Cloudflare. If onboarding a new domain: apply DNS records first, update nameservers at the registrar, wait for the zone to become active, then apply again to create the Access applications.
