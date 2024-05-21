{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    networking = {
      wireless = {
        enable = true;
        fallbackToWPA2 = false;
        environmentFile = "/run/secrets/wifi.env";

        networks = {
          "@HOME_WIFI_NAME@" = {
            pskRaw = "@HOME_WIFI_PASSWORD_PSK_RAW@";
            authProtocols = [
              "SAE"
              "WPA-PSK-SHA256"
              "WPA-PSK"
            ];
            extraConfig = ''
            ieee80211w=2
            '';
          };
        };
      };
    };
  };
}
