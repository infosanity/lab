# WARP
Warp is the client-side of a [CloudFlared](cloudflared.md) tunnel
```
WARP is a device client that builds proxy tunnels using either Wireguard or MASQUE, and builds a DNS proxy using DNS-over-HTTPS. WARP supports all major operating systems, all common forms of endpoint management tooling, and has a robust series of management parameters and profiles to accurately scope the needs of a diverse user base.
```
[Vendor Docs](https://developers.cloudflare.com/cloudflare-one/connections/connect-devices/warp/)

## Install WARP Client
### Ubuntu
[Vendor Docs](https://pkg.cloudflareclient.com/)
```shell
# Add cloudflare gpg key
curl -fsSL https://pkg.cloudflareclient.com/pubkey.gpg | sudo gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg


# Add this repo to your apt repositories
echo "deb [signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflare-client.list


# Install
sudo apt-get update && sudo apt-get install cloudflare-warp
```

#### Register Client - Via CLI
```
warp-cli register new <your-team-name>
```
_Team name accessed from CloudFlare portal: Zero-Trust > Settings > Custom Pages_

##### Troubleshooting - headless system
If environment can't spawn a browser session, the authentication token needs to be generated via a different system, and presented to the warp-cli client manually

1) authenticate to: https://\<your-team-name\>.cloudflareaccess.com/warp
2) from page source, extract token from the **open Cloudflare WARP** button. HREF will look similar to:
```onclick="location.href = 'com.cloudflare.warp://infosanity.cloudflareaccess.com/auth?token=ey```
3) from your terminal, take the link above and feed into command:

```
warp-cli --accept-tos registration token 'com.cloudflare.warp://<TEAM-NAME>.cloudflareaccess.com/auth?token=<TOKEN>
```