{
  description = "Nix-anywhere configurations for multiple machines";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    }
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };
    home-manager = {
      url = "github:community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, ... }@attrs: {
    nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ({modulesPath, ... }: {
          imports = [
            disko.nixosModules.disko
          ];
          disko.devices = import ./configs/disk.nix {
            lib = nixpkgs.lib;
          };

          time.timeZone = "Australia/Melbourne";

          networking = {
            hostName = "arch-desktop";
            networkmanager = {
              enable = true;
            };
          };

          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
          };

          services.openssh.enable = true;

          users.users.melcloud = {
            isNormalUser  = true;
            createHome = true;
            home  = "/home/melcloud";
            description  = "Yin Zhang";
            extraGroups  = [ "wheel" ];
            openssh.authorizedKeys.keys  = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIApLidbYFIOizYohiVhASUW2iXZu+anuJF5PE/8QDQ4J nixos@nixos"
            ];
          };
        })
      ];
    };
  };
};
