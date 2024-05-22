# NixOS configurations
Configurations used to bootstrap my computers through nixos-anywhere

# Installation ISO
Use `make build_iso` to build an installation ISO with pre-set ssh key

## WIFI
Once booted from installation ISO, run following command to set up WIFI:

```bash
read -rp "WIFI SSID: "$'\n' WIFI_SSID
read -srp "WIFI password: "$'\n' WIFI_PASSWORD

cat <<EOF > /run/secrets/wifi.env
HOME_WIFI_NAME="$WIFI_SSID"
HOME_WIFI_PASSWORD_PSK_RAW=$(wpa_passphrase "$WIFI_SSID" "$WIFI_PASSWORD" | grep -E '^\s+psk' | cut -d'=' -f2)
EOF
```
