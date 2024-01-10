{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    services = {
      chrony = {
        enable = true;
      };
    };
  };
}
