# NixOS configurations
Configurations used to bootstrap my computers through nixos-anywhere

# Installation ISO
Use `make build_iso` to build an installation ISO with pre-set ssh key

## WIFI
Once booted from installation ISO, run following command to set up WIFI:

```bash
read -rp "WIFI SSID: "$'\n' WIFI_SSID
read -srp "WIFI password: "$'\n' WIFI_PASSWORD

sudo mkdir -p /run/secrets/
cat <<EOF | sudo tee /run/secrets/wifi.env > /dev/null
HOME_WIFI_NAME="$WIFI_SSID"
HOME_WIFI_PASSWORD_PSK="${WIFI_PASSWORD/&/\\&}"
EOF
```

## Build ISO
```bash
nix build '.#iso'
```

## Run nix-anywhere
```bash
nix run github:nix-community/nixos-anywhere -- --flake '.#<target>' root@<target IP>
```

## Development
```bash
nix fmt
nix flake lock
nix flake show
```
