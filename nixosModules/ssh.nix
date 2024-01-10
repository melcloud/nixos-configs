{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    programs.ssh = {
      startAgent = true;
    };
    services = {
      openssh = {
        enable = true;
        startWhenNeeded = true;
        settings = {
          AllowGroups = [
            "sftp-user"
            "ssh-user"
            "ssh-svc-account"
          ];
          PermitRootLogin = lib.mkForce "no";
          PasswordAuthentication = false;
        };
        extraConfig = ''
          Match Group ssh-user
            PubkeyAuthOptions verify-required
        '';
      };
    };
  };
}
