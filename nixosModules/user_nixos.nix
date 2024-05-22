{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  users.users.nixos = {
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILwGInIGXAhrdBhLSfU4OigLt0bhKS7lJjh48nD/zOpfAAAAE3NzaDpuaXhvcy1pbnN0YWxsZXI= melcloud@frame-arch"
    ];
    extraGroups = [
      "ssh-user"
    ];
  };
}
