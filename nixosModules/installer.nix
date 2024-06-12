{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    # nix-anywhere must run as root
    users.users.root = {
      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILwGInIGXAhrdBhLSfU4OigLt0bhKS7lJjh48nD/zOpfAAAAE3NzaDpuaXhvcy1pbnN0YWxsZXI= melcloud@frame-arch"
      ];
    };
    # enable root login, but enforce U2F check
    services = {
      openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = false;
        };
        extraConfig = ''
          PubkeyAuthOptions verify-required
        '';
      };
    };
    networking = {
      wireless = {
        enable = true;
        fallbackToWPA2 = false;
        environmentFile = "/run/secrets/wifi.env";
        extraConfig = ''
        country=AU
        '';
        networks = {
          "@HOME_WIFI_NAME@" = {
            psk = "@HOME_WIFI_PASSWORD_PSK@";
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
