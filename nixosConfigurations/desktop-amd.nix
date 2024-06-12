{ inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.disko.nixosModules.disko
      ./btrfs.nix
      inputs.self.nixosModules.boot
      inputs.self.nixosModules.culture
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.ntp
      inputs.self.nixosModules.wifi
    ];
    config = {
      system = {
        stateVersion = "24.05";
      };
    };
  };
in
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixosModule
  ];
}
