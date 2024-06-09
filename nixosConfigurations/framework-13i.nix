{ system, inputs, ... }@flakeContext:
let
  nixosModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.disko.nixosModules.disko { swapSize = "32G" }
      inputs.nixos-hardware.nixModules.framework-12th-gen-intel
    ];
    config = {
      system = {
        stateVersion = "24.05";
      };
    };
  };
in
inputs.nixpkgs.lib.nixosSystem {
  system = "${system}";
  modules = [
    nixosModule
  ];
}
