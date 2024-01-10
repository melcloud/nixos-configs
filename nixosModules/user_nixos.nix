{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  users.users.nixos = {
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFq1f00Z7ifUTw0AbeEwzWB3C+dbAofYRx1bz4eZVyZMAAAAE3NzaDpuaXhvcy1pbnN0YWxsZXI="
    ];
    extraGroups = [
      "ssh-user"
    ];
  };
}
