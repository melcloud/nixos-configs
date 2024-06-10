{
  description = "nixos settings for my machines";
  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
  };
  outputs = { self, systems, nixpkgs, disko, nixos-hardware, ... }@inputs:
    let
      removeExtension = fileName: builtins.replaceStrings [ ".nix" ] [ "" ] fileName;

      defaultSystem = "x86_64-linux";

      eachSystem = nixpkgs.lib.genAttrs (import systems);

      flakeContext = {
        inherit inputs;
      };
    in
    {
      # use nixpkgs-fmt for 'nix fmt'
      formatter.${defaultSystem} = nixpkgs.legacyPackages.${defaultSystem}.nixpkgs-fmt;

      nixosModules = builtins.listToAttrs (map
        (fileName: {
          name = removeExtension fileName;
          value = import (./nixosModules + "/${fileName}") flakeContext;
        })
        (builtins.attrNames (builtins.readDir ./nixosModules))
      );

      nixosConfigurations = eachSystem (system:
        builtins.listToAttrs (map
          (fileName: {
            name = removeExtension fileName;
            value = import (./nixosConfigurations + "/${fileName}") ({ system = "${system}"; } // flakeContext);
          })
          (builtins.attrNames (builtins.readDir ./nixosConfigurations))
        )
      );

      packages = eachSystem (system:
        builtins.listToAttrs (map
          (fileName: {
            name = removeExtension fileName;
            value = import (./packages + "/${fileName}") ({ system = "${system}"; } // flakeContext);
          })
          (builtins.attrNames (builtins.readDir ./packages))
        )
      );
    };
}
