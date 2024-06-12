{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    boot.loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      }
        };
    };
  }
