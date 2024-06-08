{ system, inputs, ... }@flakeContext:
let
  installerFormat = {
    "aarch64-linux" = "sd-aarch64-installer";
    "x86_64-linux"  = "install-iso";
  };

  nixosModule = { config, lib, pkgs, ... }: {
    imports = [
      inputs.self.nixosModules.ssh
      inputs.self.nixosModules.user_nixos
      inputs.self.nixosModules.ntp
      inputs.self.nixosModules.installer_wifi
    ];
    config = {
      system = {
        stateVersion = "24.05";
      };
    };
  };
in
inputs.nixos-generators.nixosGenerate {
  system = "${system}";
  format = installerFormat.${system};
  modules = [
    nixosModule
  ];
}
