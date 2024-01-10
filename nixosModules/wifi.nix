{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    networking = {
      wireless = {
        enable = lib.mkForce false;
        iwd.enable = true;
      };

      networkmanager = {
        enable = true;
        wifi = {
          backend = "iwd";
        };
        ensureProfiles = {
          environmentFiles = [
            /run/secrets/networkmanager.env
          ];
          profiles = {
            home-wifi = {
              connection = {
                id = "@HOME_WIFI_NAME@";
                permissions = "";
                type = "wifi";
                zone = "home";
              };
              ipv4 = {
                method = "auto";
              };
              ipv6 = {
                addr-gen-mode = "stable-privacy";
                method = "auto";
              };
              wifi = {
                mode = "infrastructure";
                ssid = "@HOME_WIFI_NAME@";
              };
              wifi-security = {
                key-mgmt = "@HOME_WIFI_AUTH_MODE@";
                psk = "@HOME_WIFI_PASSWORD@";
              };
            };
          };
        };
      };
    };
  };
}
