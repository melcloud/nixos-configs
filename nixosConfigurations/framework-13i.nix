{ inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.disko.nixosModules.disko
      ./btrfs.nix
      inputs.nixos-hardware.nixModules.framework-12th-gen-intel
    ];
    config = {
      system = {
        stateVersion = "24.05";
      };
    };
  };
in
inputs.nixpkgs.lib.nixosSystem
{
  system = "x86_64-linux";
  modules = [
    nixosModule
  ];
}
